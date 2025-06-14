//
//  HomeViewController.swift
//  StreamFlix
//
//  Created by Macbook on 23/05/2025.
//

import UIKit
import SwiftUI

enum Sections: String, CaseIterable {
    case TrendingMovies = "Trending Movies"
    case TrendingTV = "Trending TV"
    case Popular = "Popular"
    case Upcoming = "Upcoming"
    case TopRated = "Top Rated"
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let sections: [Sections] = Sections.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configureNavBar()
        APICaller.shared.getTrendingMovies(completion: { [weak self] trendingMoviesResponse in
            print(trendingMoviesResponse)
        })
    }
    func setupUI() {
        self.setupTableViewHeader()
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
        UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].rawValue
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .label
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.frame = .init(x: view.bounds.origin.x + 20, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}

//struct HomeViewControllerRepresentable: UIViewControllerRepresentable {
//    
//    typealias UIViewControllerType = HomeViewController
//    
//    func makeUIViewController(context: Context) -> HomeViewController {
//        return HomeViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
//        
//    }
//    
//}
//
//struct HomeViewControllerPreviewViewRepresentable_Preview: PreviewProvider {
//    static var previews: some View {
//        HomeViewControllerRepresentable()
//    }
//}


