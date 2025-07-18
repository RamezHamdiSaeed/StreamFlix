//
//  HomeViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//

class HomeViewModel {
    
    let getPopularMoviesUseCase: GetPopularMoviesUseCase
    let getPopularMoviesObservable: Observable<Result<Title, APIError>> = .init(value: .success(Title(page: 1, results: [])))
    var popularMovies: Title?
    var coordinator: BaseCoordinator
    
    init(getPopularMoviesUseCase: GetPopularMoviesUseCase = GetPopularMoviesUseCaseImpl(), coordinator: HomeViewCoordinator) {
        self.getPopularMoviesUseCase = getPopularMoviesUseCase
        self.coordinator = coordinator
    }
    
    func fetchPopularMovies() {
        self.getPopularMoviesUseCase.getPopularMovies { [weak self] result in
            switch result {
            case .success(let title):
                self?.getPopularMoviesObservable.value = .success(title)
            case .failure(let error):
                self?.getPopularMoviesObservable.value = .failure(error)
            }
        }
    }
}
