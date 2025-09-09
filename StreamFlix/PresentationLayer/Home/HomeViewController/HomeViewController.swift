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
    var refresher: UIRefreshControl = UIRefreshControl()
    var noDataTableViewFeedbackImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "No Data")
        return imageView
    }()

    var viewModel: HomeViewModel?
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBinding()
        self.configureNavBar()
        
        // Load cached data first to show something immediately
        self.viewModel?.loadCachedData()
        
        // Then fetch fresh data
        self.viewModel?.fetchAllSectionsData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Only rebuild view models if we have data, don't trigger unnecessary reloads
        if let viewModel = self.viewModel, viewModel.hasData() {
            self.viewModel?.buildViewModels()
        }
    }

    func setupUI() {
         self.setupTableView()
    }

    func showNoDataTableViewFeedback(isVisible: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isVisible {
                self?.addSubViewOfNoDataTableViewFeedback()
                return
            }
            self?.noDataTableViewFeedbackImage.removeFromSuperview()
        }
    }

    func addSubViewOfNoDataTableViewFeedback() {
        let safeAreaTopInset = self.view.safeAreaInsets.top
        let tableViewRefresherSpace = 20.0
        self.noDataTableViewFeedbackImage.frame = CGRect(x: 0,
        y: self.tableView.frame.origin.y + safeAreaTopInset + tableViewRefresherSpace,
        width: self.tableView.frame.width,
        height: self.tableView.frame.height - safeAreaTopInset - tableViewRefresherSpace)
        self.view.addSubview(self.noDataTableViewFeedbackImage)
    }

    func setupBinding() {
        // Improved reactive binding with better error handling
        self.viewModel?.$sectionViewModels
            .receive(on: DispatchQueue.main) // Ensure UI updates happen on main thread
            .sink { [weak self] sectionViewModels in
                print("📱 Received section view models update: \(sectionViewModels.count) sections")
                self?.tableView.reloadData()
                self?.refresher.endRefreshing()
                self?.showNoDataTableViewFeedback(isVisible: sectionViewModels.isEmpty)
        }
        .store(in: &cancellables)
        
        // Add loading state binding if you have one in your view model
        self.viewModel?.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading && !(self?.refresher.isRefreshing ?? false) {
                    // Show loading indicator if not already refreshing
                }
            }
            .store(in: &cancellables)
    }

    func setupTableView() {
        self.tableView.register(UINib(nibName: RandomMoviePreviewViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: RandomMoviePreviewViewCell.identifier)
        self.tableView.register(UINib(nibName: CollectionViewTableViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        self.setupTableViewRefresher()
    }

    func setupTableViewRefresher() {
        refresher.tintColor = .systemGray
        refresher.backgroundColor = .systemBackground
        refresher.addTarget(self, action: #selector(self.refreshTableView), for: .valueChanged)
        self.tableView.addSubview(refresher)
    }

    @objc func refreshTableView() {
        print("🔄 Manual refresh triggered")
        self.viewModel?.fetchAllSectionsData()
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
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.transform = .identity
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel?.sectionViewModels[section].rowViewModels.count ?? 0
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = self.viewModel?.sectionViewModels[indexPath.section],
              indexPath.row < section.rowViewModels.count else {
            return UITableViewCell()
        }
        
        let row = section.rowViewModels[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier()) as? RowViewCell {
            cell.setup(with: row)
            return cell as? UITableViewCell ?? UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.viewModel?.sectionViewModels.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel?.sectionViewModels[section].sectionModel.headerTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView,
              let sectionViewModel = self.viewModel?.sectionViewModels[section] else { return }
        
        header.textLabel?.textColor = .label
        header.textLabel?.text = sectionViewModel.sectionModel.headerTitle
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.frame = .init(x: view.bounds.origin.x + 20,
                             y: view.bounds.origin.y,
                             width: view.bounds.width,
                             height: view.bounds.height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
