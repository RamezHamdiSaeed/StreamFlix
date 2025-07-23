//
//  HomeViewController.swift
//  StreamFlix
//
//  Created by Macbook on 23/05/2025.
//

import UIKit
import Combine


class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: HomeViewModel?
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBinding()
        self.configureNavBar()
        self.viewModel?.buildViewModels()
        self.viewModel?.fetchAllSectionsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.buildViewModels()
    }
    
    func setupUI() {
         self.setupTableView()
    }
    
    func setupBinding() {
        // here i'm using debounce to prevent many threads in the background changing the Published property (Observable) at the same time so i add at least 500 milli secons between every change of the observable and getting notified here
        self.viewModel?.$sectionViewModels.dropFirst().debounce(for: .milliseconds(500), scheduler: RunLoop.main).sink { [weak self] sectionViewModels in
                self?.tableView.reloadData()
        }
        .store(in: &cancellables)
    }

    func setupTableView(){
        self.tableView.register(UINib(nibName: RandomMoviePreviewViewCell.identifier, bundle: nil), forCellReuseIdentifier: RandomMoviePreviewViewCell.identifier)
        self.tableView.register(UINib(nibName: CollectionViewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
    }

    func configureNavBar() {
        var leftImage = UIImage(named: "netflix_logo")
        leftImage = leftImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .done, target: self, action: nil)
        let rightImages = [UIImage(systemName: "person"), UIImage(systemName: "play.rectangle")]
        navigationItem.rightBarButtonItems = rightImages.map {
            UIBarButtonItem(image: $0, style: .done, target: self, action: nil)
        }
            navigationController?.navigationBar.tintColor = .white
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.transform = .identity
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.sectionViewModels[section].rowViewModels.count ?? 0
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Trending Movies"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        let section = self.viewModel?.sectionViewModels[section]
        header.textLabel?.textColor = .label
        header.textLabel?.text = section?.sectionModel.headerTitle
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.frame = .init(x: view.bounds.origin.x + 20, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}


