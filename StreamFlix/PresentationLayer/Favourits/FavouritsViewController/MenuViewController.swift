//
//  MenuViewController.swift
//  StreamFlix
//
//  Created by Macbook on 23/05/2025.
//

import UIKit
import Combine

class MenuViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var noDataTableViewFeedbackImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "No Data")
        return imageView
    }()

    var viewModel: MenuViewModel?
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.retrieveFavoriteMovies()
    }

    func setupUI() {
        self.setupTableView()
        if let useCase = self.viewModel?.retrieveFavoriteMoviesUseCase as? GetMoviesSearchUseCase {
            self.viewModel?.searchForMoviesByQuery = useCase
            self.setupSearchController()
        }
    }
    
    func setupSearchController() {
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = self.searchController
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search here ..."
        definesPresentationContext = false
    }
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func showNoDataTableViewFeedback(isVisible: Bool) {
        if isVisible {
            self.addSubViewOfNoDataTableViewFeedback()
            return
        }
        self.noDataTableViewFeedbackImage.removeFromSuperview()
    }

    func addSubViewOfNoDataTableViewFeedback() {
        self.noDataTableViewFeedbackImage.frame = CGRect(x: 0,
        y: self.tableView.frame.origin.y,
        width: self.tableView.frame.width,
        height: self.tableView.frame.height)
        self.view.addSubview(self.noDataTableViewFeedbackImage)
    }

    func setupBinding() {
        self.viewModel?.$sectionViewModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sectionViewModels in
                self?.showNoDataTableViewFeedback(isVisible: sectionViewModels.isEmpty)
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.viewModel?.sectionViewModels[indexPath.section]
        let row = section?.rowViewModels[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: row?.cellIdentifier() ?? "") as? RowViewCell {
            cell.setup(with: row)
            return cell as? UITableViewCell ?? UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        self.viewModel?.sectionViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.viewModel?.sectionViewModels[section].rowViewModels.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.viewModel?.sectionViewModels[indexPath.section]
        let row = section?.rowViewModels[indexPath.row]
        if let cell = row as? CellPressible {
            cell.cellPressed()
        }
    }
}

extension MenuViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchController.searchBar.text
        self.viewModel?.searchForMoviesByQuery?.getSearchMovies(query: query) { result in
            switch result {
            case .success(let title):
                self.viewModel?.favoriteMovies = title.results
                self.viewModel?.buildViewModels()
            case .failure:
                self.viewModel?.favoriteMovies = []
                self.viewModel?.buildViewModels()
            }
        }
        searchBar.resignFirstResponder()
    }
}
