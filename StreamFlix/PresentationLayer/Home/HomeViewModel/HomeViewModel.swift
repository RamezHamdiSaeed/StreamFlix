//
//  HomeViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//

class HomeViewModel {
    
    let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    let getTrendingTVUseCase: GetTrendingTVUseCase
    let getPopularMoviesUseCase: GetPopularMoviesUseCase
    let getUpcommingMoviesUseCase: GetUpcommingMoviesUseCase
    let topRatedMoviesUseCase: GetTopRatedMoviesUseCase
    
    let sectionViewModels: Observable<[SectionViewModel]> = Observable(value: [])

    var trendingMovies: [Movie] = []
    var trendingTV: [Movie] = []
    var popularMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    
    
    var coordinator: BaseCoordinator
    
    init(getTrendingMoviesUseCase: GetTrendingMoviesUseCase = GetTrendingMoviesUseCaseImpl(), getTrendingTVUseCase: GetTrendingTVUseCase = GetTrendingTVUseCaseImpl(), getPopularMoviesUseCase: GetPopularMoviesUseCase = GetPopularMoviesUseCaseImpl(), getUpcommingMoviesUseCase: GetUpcommingMoviesUseCase = GetUpcommingMoviesUseCaseImpl(), topRatedMoviesUseCase: GetTopRatedMoviesUseCase = GetTopRatedMoviesUseCaseImpl(), coordinator: HomeViewCoordinator) {
        self.getTrendingMoviesUseCase = getTrendingMoviesUseCase
        self.getTrendingTVUseCase = getTrendingTVUseCase
        self.getPopularMoviesUseCase = getPopularMoviesUseCase
        self.getUpcommingMoviesUseCase = getUpcommingMoviesUseCase
        self.topRatedMoviesUseCase = topRatedMoviesUseCase
        self.coordinator = coordinator
    }
    
    func buildViewModels() {
        
        var sectionViewModels = [SectionViewModel]()
        
        sectionViewModels.append(self.randomMoviePreviewRowSectionViewModel(movie: trendingMovies.randomElement() ?? Movie(backdropPath: nil, id: nil, title: nil, originalTitle: nil, overview: nil, posterPath: nil, mediaType: nil, adult: nil, originalLanguage: nil, genreIds: nil, popularity: nil, releaseDate: nil, video: nil, voteAverage: nil, voteCount: nil)))
        
        sectionViewModels.append(self.trendingMoviesRowSectionViewModel(movies: trendingMovies))
        sectionViewModels.append(self.trendingTVRowSectionViewModel(movies: trendingTV))
        sectionViewModels.append(self.popularRowSectionViewModel(movies: popularMovies))
        sectionViewModels.append(self.upcomingRowSectionViewModel(movies: upcomingMovies))
        sectionViewModels.append(self.topRatedRowSectionViewModel(movies: topRatedMovies))
        
        
        self.sectionViewModels.value = sectionViewModels
    }
    
    // MARK: RandomMoviePreviewRowSectionViewModel
    
    func randomMoviePreviewRowSectionViewModel(movie: Movie) -> SectionViewModel {

        let RandomMoviePreviewRowSectionModel = SectionModel(headerTitle: "", headerHeight: 0)
        
        var RandomMoviePreviewRowViewModels: [RowViewModel] = []
        
        RandomMoviePreviewRowViewModels.append(self.getRandomMoviePreviewRowViewModel(movie: movie))
        
        let tRandomMoviePreviewRowSectionViewModel = SectionViewModel(sectionModel: RandomMoviePreviewRowSectionModel, rowViewModels: RandomMoviePreviewRowViewModels)
        return tRandomMoviePreviewRowSectionViewModel
    }
    
    func getRandomMoviePreviewRowViewModel(movie: Movie) -> RowViewModel {
        RandomMoviePreviewViewModel(randomMovie: movie)
    }
    
    //MARK: TrendingMovies Section
    
    func trendingMoviesRowSectionViewModel(movies: [Movie]) -> SectionViewModel {

        let trendingMoviesRowSectionModel = SectionModel(headerTitle: "Trending Movies", headerHeight: 200)
        
        var trendingMoviesRowViewModels: [RowViewModel] = []
        
        trendingMoviesRowViewModels.append(self.getTrendingMoviesRowViewModel(movies: movies))
        
        let trendingMoviesRowSectionViewModel = SectionViewModel(sectionModel: trendingMoviesRowSectionModel, rowViewModels: trendingMoviesRowViewModels)
        return trendingMoviesRowSectionViewModel
    }
    
    func getTrendingMoviesRowViewModel(movies: [Movie]) -> RowViewModel {
        CollectionViewTableViewCellViewModel(movies: movies) { [weak self] movie in
            if let coordinator = self?.coordinator as? HomeViewCoordinator {
                coordinator.navToVC(presentType: .fullScreen , distination: .movieDetails(movie, .fullScreen))
            }
        }
        
    }
    
    //MARK: TrendingTV Section
    
    func trendingTVRowSectionViewModel(movies: [Movie]) -> SectionViewModel {
        let trendingMoviesRowSectionModel = SectionModel(headerTitle: "Trending TV", headerHeight: 200)
        
        var trendingMoviesRowViewModels: [RowViewModel] = []
        
        trendingMoviesRowViewModels.append(self.getTrendingTVRowViewModel(movies: movies))
        
        let trendingMoviesRowSectionViewModel = SectionViewModel(sectionModel: trendingMoviesRowSectionModel, rowViewModels: trendingMoviesRowViewModels)
        return trendingMoviesRowSectionViewModel
    }
    
    func getTrendingTVRowViewModel(movies: [Movie]) -> RowViewModel {
        CollectionViewTableViewCellViewModel(movies: movies) { [weak self] movie in
            if let coordinator = self?.coordinator as? HomeViewCoordinator {
                coordinator.navToVC(presentType: .fullScreen , distination: .movieDetails(movie, .fullScreen))
            }
        }
    }
    
    //MARK: Popular Section
    
    func popularRowSectionViewModel(movies: [Movie]) -> SectionViewModel {
        let trendingMoviesRowSectionModel = SectionModel(headerTitle: "Popular", headerHeight: 200)
        
        var trendingMoviesRowViewModels: [RowViewModel] = []
        
        trendingMoviesRowViewModels.append(self.getPopularRowViewModel(movies: movies))
        
        let trendingMoviesRowSectionViewModel = SectionViewModel(sectionModel: trendingMoviesRowSectionModel, rowViewModels: trendingMoviesRowViewModels)
        return trendingMoviesRowSectionViewModel
    }
    
    func getPopularRowViewModel(movies: [Movie]) -> RowViewModel {
        CollectionViewTableViewCellViewModel(movies: movies) { [weak self] movie in
            if let coordinator = self?.coordinator as? HomeViewCoordinator {
                coordinator.navToVC(presentType: .fullScreen , distination: .movieDetails(movie, .fullScreen))
            }
        }
    }
    
    //MARK: UpcomingMovings Section

    func upcomingRowSectionViewModel(movies: [Movie]) -> SectionViewModel {
        let trendingMoviesRowSectionModel = SectionModel(headerTitle: "Upcoming movies", headerHeight: 200)

        var trendingMoviesRowViewModels: [RowViewModel] = []
        
        trendingMoviesRowViewModels.append(self.getUpcomingRowViewModel(movies: movies))
        
        let trendingMoviesRowSectionViewModel = SectionViewModel(sectionModel: trendingMoviesRowSectionModel, rowViewModels: trendingMoviesRowViewModels)
        return trendingMoviesRowSectionViewModel
    }
    
    func getUpcomingRowViewModel(movies: [Movie]) -> RowViewModel {
        CollectionViewTableViewCellViewModel(movies: movies) { [weak self] movie in
            if let coordinator = self?.coordinator as? HomeViewCoordinator {
                coordinator.navToVC(presentType: .fullScreen , distination: .movieDetails(movie, .fullScreen))
            }
        }
    }
    
    //MARK: Top Rated Section
    
    func topRatedRowSectionViewModel(movies: [Movie]) -> SectionViewModel {
        let trendingMoviesRowSectionModel = SectionModel(headerTitle: "Top Rated", headerHeight: 200)
        
        var trendingMoviesRowViewModels: [RowViewModel] = []
        
        trendingMoviesRowViewModels.append(self.getTopRatedRowViewModel(movies: movies))
        
        let trendingMoviesRowSectionViewModel = SectionViewModel(sectionModel: trendingMoviesRowSectionModel, rowViewModels: trendingMoviesRowViewModels)
        return trendingMoviesRowSectionViewModel
    }
    
    func getTopRatedRowViewModel(movies: [Movie]) -> RowViewModel {
        CollectionViewTableViewCellViewModel(movies: movies) { [weak self] movie in
            if let coordinator = self?.coordinator as? HomeViewCoordinator {
                coordinator.navToVC(presentType: .fullScreen , distination: .movieDetails(movie, .fullScreen))
            }
        }
    }
}

extension HomeViewModel {
    func getTrendingMovies() {
        self.getTrendingMoviesUseCase.getTrendingMovies { [weak self] trendingMovies in
            switch trendingMovies {
            case .success(let Title):
                self?.trendingMovies = Title.results
                self?.buildViewModels()
            case .failure(let error):
                print("Error in fetching trending movies: \(error)")
            }
        }
    }
    
    func getTrendingTV() {
        self.getTrendingTVUseCase.getTrendingTV { [weak self] trendingTV in
            switch trendingTV {
            case .success(let Title):
                self?.trendingTV = Title.results
                self?.buildViewModels()
            case .failure(let error):
                print("Error in fetching trending TV: \(error)")
            }
        }
    }
    
    
    func getPopularMovies() {
        self.getPopularMoviesUseCase.getPopularMovies { [weak self] popularMovies in
            switch popularMovies {
            case .success(let Title):
                self?.popularMovies = Title.results
                self?.buildViewModels()
            case .failure(let error):
                print("Error in fetching popular movies: \(error)")
            }
        }
    }
    
    func getUpcomingMovies() {
        self.getUpcommingMoviesUseCase.getUpcommingMovies { [weak self] upcomingMovies in
            switch upcomingMovies {
            case .success(let Title):
                self?.upcomingMovies = Title.results
                self?.buildViewModels()
            case .failure(let error):
                print("Error in fetching upcomingMovies: \(error)")
            }
        }
    }
    
    func getTopRatedMovies() {
        self.topRatedMoviesUseCase.getTopRatedMovies { [weak self] topRatedMovies in
            switch topRatedMovies {
            case .success(let Title):
                self?.topRatedMovies = Title.results
                self?.buildViewModels()
            case .failure(let error):
                print("Error in fetching topRatedMovies: \(error)")
            }
        }
    }
}
