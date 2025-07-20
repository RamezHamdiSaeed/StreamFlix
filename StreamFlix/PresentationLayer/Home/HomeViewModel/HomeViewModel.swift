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
    let isLoading: Observable<Bool> = Observable(value: false)

    var trendingMovies: [Movie] = []
    var isTrendingMoviesRequestLoading = false
    var trendingTV: [Movie] = []
    var isTrendingTVRequestLoading = false
    var popular: [Movie] = []
    var isPopularRequestLoading = false
    var upcoming: [Movie] = []
    var isUpcomingRequestLoading = false
    var topRated: [Movie] = []
    var isTopRatedRequestLoading = false
    
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
        
            sectionViewModels.append(self.trendingMoviesRowSectionViewModel(movies: trendingMovies))
            sectionViewModels.append(self.trendingTVRowSectionViewModel(movies: trendingTV))
            sectionViewModels.append(self.popularRowSectionViewModel(movies: popular))
            sectionViewModels.append(self.upcomingRowSectionViewModel(movies: upcoming))
            sectionViewModels.append(self.topRatedRowSectionViewModel(movies: topRated))
        
        
        self.sectionViewModels.value = sectionViewModels
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
        CollectionViewTableViewCellViewModel(movies: movies, getMoviesUseCase: self.getTrendingMoviesUseCase as! UseCase<Title>, isLoading: self.isTrendingMoviesRequestLoading){ [weak self] title in
            self?.trendingMovies = title.results
            self?.buildViewModels()
        } updateLoadingStatus: { [weak self] isLoading in
            self?.isTrendingMoviesRequestLoading = isLoading
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
        CollectionViewTableViewCellViewModel(movies: movies, getMoviesUseCase: self.getTrendingTVUseCase as! UseCase<Title>, isLoading: self.isTrendingTVRequestLoading) { [weak self] title in
            self?.trendingTV = title.results
            self?.buildViewModels()
        } updateLoadingStatus: { [weak self] isLoading in
            self?.isTrendingTVRequestLoading = isLoading
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
        CollectionViewTableViewCellViewModel(movies: movies, getMoviesUseCase: self.getPopularMoviesUseCase as! UseCase<Title>, isLoading: self.isPopularRequestLoading) { [weak self] title in
            self?.popular = title.results
            self?.buildViewModels()
        } updateLoadingStatus: { [weak self] isLoading in
            self?.isPopularRequestLoading = isLoading
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
        CollectionViewTableViewCellViewModel(movies: movies, getMoviesUseCase: self.getUpcommingMoviesUseCase as! UseCase<Title>, isLoading: self.isUpcomingRequestLoading) { [weak self] title in
            self?.upcoming = title.results
            self?.buildViewModels()
        } updateLoadingStatus: { [weak self] isLoading in
            self?.isUpcomingRequestLoading = isLoading
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
        CollectionViewTableViewCellViewModel(movies: movies, getMoviesUseCase: self.topRatedMoviesUseCase as! UseCase<Title>, isLoading: self.isTopRatedRequestLoading) { [weak self] title in
            self?.topRated = title.results
            self?.buildViewModels()
        } updateLoadingStatus: { [weak self] isLoading in
            self?.isTopRatedRequestLoading = isLoading
        }
    }
}
