//
//  HomeViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//
import Combine
import Foundation

enum MoviesSection: String {
    case trendingMovies = "Trending Movies"
    case trendingTV = "Trending TV"
    case popular = "Popular"
    case upcomingMovies = "Upcoming movies"
    case topRated = "Top Rated"
}

class HomeViewModel: ObservableObject {

    let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    let getTrendingTVUseCase: GetTrendingTVUseCase
    let getPopularMoviesUseCase: GetPopularMoviesUseCase
    let getUpcommingMoviesUseCase: GetUpcommingMoviesUseCase
    let topRatedMoviesUseCase: GetTopRatedMoviesUseCase

    @Published var sectionViewModels: [SectionViewModel] = []
    @Published var isLoading: Bool = false
    
    var trendingMovies: [Movie] = [] {
        didSet { buildViewModelsIfReady() }
    }
    var trendingTV: [Movie] = [] {
        didSet { buildViewModelsIfReady() }
    }
    var popularMovies: [Movie] = [] {
        didSet { buildViewModelsIfReady() }
    }
    var upcomingMovies: [Movie] = [] {
        didSet { buildViewModelsIfReady() }
    }
    var topRatedMovies: [Movie] = [] {
        didSet { buildViewModelsIfReady() }
    }

    var isFavoriteMovieUseCase: IsFavoriteMovieUseCase?
    var favoriteMovieUseCase: FavoriteMovieUseCase?
    var unFavoriteMovieUseCase: UnFavoriteMovieUseCase?
    var insertMoviesBySectionUseCase: InsertMoviesBySectionUseCase?
    var retrieveMoviesBySectionUseCase: RetrieveMoviesBySectionUseCase?

    var coordinator: BaseCoordinator
    
    var pendingAPICallsCount = 0
    let serialQueue = DispatchQueue(label: "com.streamflix.homeviewmodel", qos: .userInitiated)

    init(getTrendingMoviesUseCase: GetTrendingMoviesUseCase = GetTrendingMoviesUseCaseImpl(),
         getTrendingTVUseCase: GetTrendingTVUseCase = GetTrendingTVUseCaseImpl(),
         getPopularMoviesUseCase: GetPopularMoviesUseCase = GetPopularMoviesUseCaseImpl(),
         getUpcommingMoviesUseCase: GetUpcommingMoviesUseCase = GetUpcommingMoviesUseCaseImpl(),
         topRatedMoviesUseCase: GetTopRatedMoviesUseCase = GetTopRatedMoviesUseCaseImpl(),
         coordinator: HomeViewCoordinator) {
        self.getTrendingMoviesUseCase = getTrendingMoviesUseCase
        self.getTrendingTVUseCase = getTrendingTVUseCase
        self.getPopularMoviesUseCase = getPopularMoviesUseCase
        self.getUpcommingMoviesUseCase = getUpcommingMoviesUseCase
        self.topRatedMoviesUseCase = topRatedMoviesUseCase
        self.coordinator = coordinator
    }
    
    func hasData() -> Bool {
        return !trendingMovies.isEmpty ||
        !trendingTV.isEmpty ||
        !popularMovies.isEmpty ||
        !upcomingMovies.isEmpty ||
        !topRatedMovies.isEmpty
    }
    
    func loadCachedData() {
        print("📦 Loading cached data...")
        
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Load cached data from Core Data
            let cachedTrendingMovies = self.retrieveMoviesBySectionUseCase?
                .retrieveMoviesBySection(sectionName: MoviesSection.trendingMovies.rawValue) ?? []
            let cachedTrendingTV = self.retrieveMoviesBySectionUseCase?
                .retrieveMoviesBySection(sectionName: MoviesSection.trendingTV.rawValue) ?? []
            let cachedPopularMovies = self.retrieveMoviesBySectionUseCase?
                .retrieveMoviesBySection(sectionName: MoviesSection.popular.rawValue) ?? []
            let cachedUpcomingMovies = self.retrieveMoviesBySectionUseCase?
                .retrieveMoviesBySection(sectionName: MoviesSection.upcomingMovies.rawValue) ?? []
            let cachedTopRatedMovies = self.retrieveMoviesBySectionUseCase?
                .retrieveMoviesBySection(sectionName: MoviesSection.topRated.rawValue) ?? []
            
            DispatchQueue.main.async {
                self.trendingMovies = cachedTrendingMovies
                self.trendingTV = cachedTrendingTV
                self.popularMovies = cachedPopularMovies
                self.upcomingMovies = cachedUpcomingMovies
                self.topRatedMovies = cachedTopRatedMovies
                
                print("📦 Cached data loaded - TrendingMovies: \(cachedTrendingMovies.count), TrendingTV: \(cachedTrendingTV.count)")
                
                // Build view models with cached data
                self.buildViewModels()
            }
        }
    }

    func buildViewModels() {
        print("🏗️ Building view models...")
        
        var sectionViewModels = [SectionViewModel]()

        if let randomMovie = trendingMovies.randomElement() {
            sectionViewModels.append(self.randomMoviePreviewRowSectionViewModel(movie: randomMovie))
        }

        if !self.trendingMovies.isEmpty {
            sectionViewModels.append(self.trendingMoviesRowSectionViewModel(movies: trendingMovies))
        }
        if !self.trendingTV.isEmpty {
            sectionViewModels.append(self.trendingTVRowSectionViewModel(movies: trendingTV))
        }
        if !self.popularMovies.isEmpty {
            sectionViewModels.append(self.popularRowSectionViewModel(movies: popularMovies))
        }
        if !self.upcomingMovies.isEmpty {
            sectionViewModels.append(self.upcomingRowSectionViewModel(movies: upcomingMovies))
        }
        if !self.topRatedMovies.isEmpty {
            sectionViewModels.append(self.topRatedRowSectionViewModel(movies: topRatedMovies))
        }

        print("🏗️ Built \(sectionViewModels.count) sections")
        self.sectionViewModels = sectionViewModels
    }
    
    private func buildViewModelsIfReady() {
        // Only rebuild if we have some data to show
        if hasData() {
            buildViewModels()
        }
    }

    // MARK: RandomMoviePreviewRowSectionViewModel

    func randomMoviePreviewRowSectionViewModel(movie: Movie) -> SectionViewModel {
        let randomMoviePreviewRowSectionModel = SectionModel(headerTitle: "", headerHeight: 0)
        var randomMoviePreviewRowViewModels: [RowViewModel] = []
        randomMoviePreviewRowViewModels.append(self.getRandomMoviePreviewRowViewModel(movie: movie))
        let tRandomMoviePreviewRowSectionViewModel = SectionViewModel(sectionModel: randomMoviePreviewRowSectionModel,
                                                                      rowViewModels: randomMoviePreviewRowViewModels)
        return tRandomMoviePreviewRowSectionViewModel
    }

    func getRandomMoviePreviewRowViewModel(movie: Movie) -> RowViewModel {
        RandomMoviePreviewViewModel(randomMovie: movie)
    }

    // MARK: TrendingMovies Section

    func trendingMoviesRowSectionViewModel(movies: [Movie]) -> SectionViewModel {
        let trendingMoviesRowSectionModel = SectionModel(headerTitle: MoviesSection.trendingMovies.rawValue,
                                                         headerHeight: 200)
        var trendingMoviesRowViewModels: [RowViewModel] = []
        trendingMoviesRowViewModels.append(self.getTrendingMoviesRowViewModel(movies: movies))
        let trendingMoviesRowSectionViewModel = SectionViewModel(sectionModel: trendingMoviesRowSectionModel,
                                                                 rowViewModels: trendingMoviesRowViewModels)
        return trendingMoviesRowSectionViewModel
    }

    func getTrendingMoviesRowViewModel(movies: [Movie]) -> RowViewModel {
       let cellViewModel = CollectionViewTableViewCellViewModel(movies: movies) { [weak self] movie in
            if let coordinator = self?.coordinator as? HomeViewCoordinator {
                coordinator.navToVC(presentType: .fullScreen, distination: .movieDetails(movie, .fullScreen))
            }
        }

        cellViewModel.isFavoriteMovieUseCase = self.isFavoriteMovieUseCase
        cellViewModel.favoriteMovieUseCase = self.favoriteMovieUseCase
        cellViewModel.unFavoriteMovieUseCase = self.unFavoriteMovieUseCase

        return cellViewModel
    }

    // MARK: TrendingTV Section

    func trendingTVRowSectionViewModel(movies: [Movie]) -> SectionViewModel {
        let trendingMoviesRowSectionModel = SectionModel(headerTitle: MoviesSection.trendingTV.rawValue,
                                                         headerHeight: 200)
        var trendingMoviesRowViewModels: [RowViewModel] = []
        trendingMoviesRowViewModels.append(self.getTrendingTVRowViewModel(movies: movies))
        let trendingMoviesRowSectionViewModel = SectionViewModel(sectionModel: trendingMoviesRowSectionModel,
                                                                 rowViewModels: trendingMoviesRowViewModels)
        return trendingMoviesRowSectionViewModel
    }

    func getTrendingTVRowViewModel(movies: [Movie]) -> RowViewModel {
        let cellViewModel = CollectionViewTableViewCellViewModel(movies: movies) { [weak self] movie in
            if let coordinator = self?.coordinator as? HomeViewCoordinator {
                coordinator.navToVC(presentType: .fullScreen, distination: .movieDetails(movie, .fullScreen))
            }
        }

        cellViewModel.isFavoriteMovieUseCase = self.isFavoriteMovieUseCase
        cellViewModel.favoriteMovieUseCase = self.favoriteMovieUseCase
        cellViewModel.unFavoriteMovieUseCase = self.unFavoriteMovieUseCase

        return cellViewModel
    }

    // MARK: Popular Section

    func popularRowSectionViewModel(movies: [Movie]) -> SectionViewModel {
        let trendingMoviesRowSectionModel = SectionModel(headerTitle: MoviesSection.popular.rawValue, headerHeight: 200)
        var trendingMoviesRowViewModels: [RowViewModel] = []
        trendingMoviesRowViewModels.append(self.getPopularRowViewModel(movies: movies))
        let trendingMoviesRowSectionViewModel = SectionViewModel(sectionModel: trendingMoviesRowSectionModel,
                                                                 rowViewModels: trendingMoviesRowViewModels)
        return trendingMoviesRowSectionViewModel
    }

    func getPopularRowViewModel(movies: [Movie]) -> RowViewModel {
        let cellViewModel = CollectionViewTableViewCellViewModel(movies: movies) { [weak self] movie in
            if let coordinator = self?.coordinator as? HomeViewCoordinator {
                coordinator.navToVC(presentType: .fullScreen, distination: .movieDetails(movie, .fullScreen))
            }
        }

        cellViewModel.isFavoriteMovieUseCase = self.isFavoriteMovieUseCase
        cellViewModel.favoriteMovieUseCase = self.favoriteMovieUseCase
        cellViewModel.unFavoriteMovieUseCase = self.unFavoriteMovieUseCase

        return cellViewModel
    }

    // MARK: UpcomingMovings Section

    func upcomingRowSectionViewModel(movies: [Movie]) -> SectionViewModel {
        let trendingMoviesRowSectionModel = SectionModel(headerTitle: MoviesSection.upcomingMovies.rawValue,
                                                         headerHeight: 200)
        var trendingMoviesRowViewModels: [RowViewModel] = []
        trendingMoviesRowViewModels.append(self.getUpcomingRowViewModel(movies: movies))
        let trendingMoviesRowSectionViewModel = SectionViewModel(sectionModel: trendingMoviesRowSectionModel,
                                                                 rowViewModels: trendingMoviesRowViewModels)
        return trendingMoviesRowSectionViewModel
    }

    func getUpcomingRowViewModel(movies: [Movie]) -> RowViewModel {
        let cellViewModel = CollectionViewTableViewCellViewModel(movies: movies) { [weak self] movie in
            if let coordinator = self?.coordinator as? HomeViewCoordinator {
                coordinator.navToVC(presentType: .fullScreen, distination: .movieDetails(movie, .fullScreen))
            }
        }

        cellViewModel.isFavoriteMovieUseCase = self.isFavoriteMovieUseCase
        cellViewModel.favoriteMovieUseCase = self.favoriteMovieUseCase
        cellViewModel.unFavoriteMovieUseCase = self.unFavoriteMovieUseCase

        return cellViewModel
    }

    // MARK: Top Rated Section

    func topRatedRowSectionViewModel(movies: [Movie]) -> SectionViewModel {
        let trendingMoviesRowSectionModel = SectionModel(headerTitle: MoviesSection.topRated.rawValue,
                                                         headerHeight: 200)
        var trendingMoviesRowViewModels: [RowViewModel] = []
        trendingMoviesRowViewModels.append(self.getTopRatedRowViewModel(movies: movies))
        let trendingMoviesRowSectionViewModel = SectionViewModel(sectionModel: trendingMoviesRowSectionModel,
                                                                 rowViewModels: trendingMoviesRowViewModels)
        return trendingMoviesRowSectionViewModel
    }

    func getTopRatedRowViewModel(movies: [Movie]) -> RowViewModel {
        let cellViewModel = CollectionViewTableViewCellViewModel(movies: movies) { [weak self] movie in
            if let coordinator = self?.coordinator as? HomeViewCoordinator {
                coordinator.navToVC(presentType: .fullScreen, distination: .movieDetails(movie, .fullScreen))
            }
        }

        cellViewModel.isFavoriteMovieUseCase = self.isFavoriteMovieUseCase
        cellViewModel.favoriteMovieUseCase = self.favoriteMovieUseCase
        cellViewModel.unFavoriteMovieUseCase = self.unFavoriteMovieUseCase

        return cellViewModel
    }
}
