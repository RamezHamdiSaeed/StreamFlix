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

class HomeViewModel {

    let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    let getTrendingTVUseCase: GetTrendingTVUseCase
    let getPopularMoviesUseCase: GetPopularMoviesUseCase
    let getUpcommingMoviesUseCase: GetUpcommingMoviesUseCase
    let topRatedMoviesUseCase: GetTopRatedMoviesUseCase

//    let sectionViewModels: Observable<[SectionViewModel]> = Observable(value: [])
    @Published var sectionViewModels: [SectionViewModel] = []

    var trendingMovies: [Movie] = []
    var trendingTV: [Movie] = []
    var popularMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var topRatedMovies: [Movie] = []

    var isFavoriteMovieUseCase: IsFavoriteMovieUseCase?
    var favoriteMovieUseCase: FavoriteMovieUseCase?
    var unFavoriteMovieUseCase: UnFavoriteMovieUseCase?
    var insertMoviesBySectionUseCase: InsertMoviesBySectionUseCase?
    var retrieveMoviesBySectionUseCase: RetrieveMoviesBySectionUseCase?

    var coordinator: BaseCoordinator

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

    func buildViewModels() {

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

        self.sectionViewModels = sectionViewModels
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

extension HomeViewModel {

    func fetchAllSectionsData() {
        let group = DispatchGroup()

        group.enter()
        self.getTrendingMovies {
            group.leave()
        }

        group.enter()
        self.getTrendingTV {
            group.leave()
        }

        group.enter()
        self.getPopularMovies {
            group.leave()
        }

        group.enter()
        self.getUpcomingMovies {
            group.leave()
        }

        group.enter()
        self.getTopRatedMovies {
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.buildViewModels()
        }
    }

    func getTrendingMovies(completion: @escaping (() -> Void)) {
        self.getTrendingMoviesUseCase.getTrendingMovies { [weak self] trendingMovies in
            defer {completion()}
            switch trendingMovies {
            case .success(let title):
                self?.trendingMovies = title.results
                self?.insertMoviesBySectionUseCase?
                    .insertMoviesBySection(movies: title.results,
                                          sectionName: MoviesSection.trendingMovies.rawValue)
            case .failure(let error):
                print("Error in fetching trending movies: \(error)")
                if  let localMoviesData = self?.retrieveMoviesBySectionUseCase?
                    .retrieveMoviesBySection(sectionName: MoviesSection.trendingMovies.rawValue),
                    !localMoviesData.isEmpty {
                    self?.trendingMovies = localMoviesData
                }
            }
        }
    }

    func getTrendingTV(completion: @escaping (() -> Void)) {
        self.getTrendingTVUseCase.getTrendingTV { [weak self] trendingTV in
            defer {completion()}
            switch trendingTV {
            case .success(let title):
                self?.trendingTV = title.results
                self?.insertMoviesBySectionUseCase?
                    .insertMoviesBySection(movies: title.results, sectionName: MoviesSection.trendingTV.rawValue)
            case .failure(let error):
                print("Error in fetching trending TV: \(error)")
                if  let localMoviesData = self?.retrieveMoviesBySectionUseCase?
                    .retrieveMoviesBySection(sectionName: MoviesSection.trendingTV.rawValue), !localMoviesData.isEmpty {
                    self?.trendingTV = localMoviesData
                }
            }
        }
    }

    func getPopularMovies(completion: @escaping (() -> Void)) {
        self.getPopularMoviesUseCase.getPopularMovies { [weak self] popularMovies in
            defer {completion()}
            switch popularMovies {
            case .success(let title):
                self?.popularMovies = title.results
                self?.insertMoviesBySectionUseCase?.insertMoviesBySection(movies: title.results,
                                                                          sectionName: MoviesSection.popular.rawValue)
            case .failure(let error):
                print("Error in fetching popular movies: \(error)")
                if  let localMoviesData = self?.retrieveMoviesBySectionUseCase?
                    .retrieveMoviesBySection(sectionName: MoviesSection.upcomingMovies.rawValue),
                    !localMoviesData.isEmpty {
                    self?.popularMovies = localMoviesData
                }
            }
        }
    }

    func getUpcomingMovies(completion: @escaping (() -> Void)) {
        self.getUpcommingMoviesUseCase.getUpcommingMovies { [weak self] upcomingMovies in
            defer {completion()}
            switch upcomingMovies {
            case .success(let title):
                self?.upcomingMovies = title.results
                self?.insertMoviesBySectionUseCase?
                    .insertMoviesBySection(movies: title.results,
                    sectionName: MoviesSection.upcomingMovies.rawValue)
            case .failure(let error):
                print("Error in fetching upcomingMovies: \(error)")
                if  let localMoviesData = self?.retrieveMoviesBySectionUseCase?
                    .retrieveMoviesBySection(sectionName: MoviesSection.upcomingMovies.rawValue),
                    !localMoviesData.isEmpty {
                    self?.upcomingMovies = localMoviesData
                }
            }
        }
    }

    func getTopRatedMovies(completion: @escaping (() -> Void)) {
        self.topRatedMoviesUseCase.getTopRatedMovies { [weak self] topRatedMovies in
            defer {completion()}
            switch topRatedMovies {
            case .success(let title):
                self?.topRatedMovies = title.results
                self?.insertMoviesBySectionUseCase?
                    .insertMoviesBySection(movies: title.results,
                                           sectionName: MoviesSection.topRated.rawValue)
            case .failure(let error):
                print("Error in fetching topRatedMovies: \(error)")
                if  let localMoviesData = self?.retrieveMoviesBySectionUseCase?
                    .retrieveMoviesBySection(sectionName: MoviesSection.topRated.rawValue),
                    !localMoviesData.isEmpty {
                    self?.topRatedMovies = localMoviesData
                }
            }
        }
    }
}
