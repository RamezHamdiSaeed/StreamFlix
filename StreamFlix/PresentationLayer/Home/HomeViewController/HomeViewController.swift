//
//  HomeViewController.swift
//  StreamFlix
//
//  Created by Macbook on 23/05/2025.
//

import UIKit

enum Sections: String, CaseIterable {
    case TrendingMovies = "Trending Movies"
    case TrendingTV = "Trending TV"
    case Popular = "Popular"
    case Upcoming = "Upcoming"
    case TopRated = "Top Rated"
}

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: HomeViewModel?
    
    let sections: [String] = Sections.allCases.map{ $0.rawValue }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBinding()
        self.configureNavBar()
        self.viewModel?.fetchPopularMovies()
    }
    
    func setupUI() {
        self.setupTableViewHeader()
         self.setupTableView()
    }
    
    func setupBinding() {
        self.viewModel?.getPopularMoviesObservable.addObserver(isFiringNow: false) { [weak self] result in
            switch result {
            case .success(let trendingTitlesResponse):
                self?.viewModel?.popularMovies = trendingTitlesResponse
                self?.tableView.reloadData()
            case .failure(let error):
                print("error fetching trending movies: \(error.localizedDescription)")
            }
        }
    }

    func setupTableView(){
        self.tableView.register(UINib(nibName: CollectionViewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
    }
    func setupTableViewHeader() {
        self.tableView.tableHeaderView = RandomMoviePreviewView.loadViewFromNib()
        guard let header = self.tableView.tableHeaderView as? RandomMoviePreviewView? else {return}
        header?.movieImageView.image = UIImage(named: "movieThumbnail", in: nil, with: .none)
        
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

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier) as? CollectionViewTableViewCell {
            cell.configure(with: self.viewModel?.popularMovies?.results ?? [])
            return cell
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        Sections.allCases.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Trending Movies"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .label
        header.textLabel?.text = sections[section]
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.frame = .init(x: view.bounds.origin.x + 20, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}


