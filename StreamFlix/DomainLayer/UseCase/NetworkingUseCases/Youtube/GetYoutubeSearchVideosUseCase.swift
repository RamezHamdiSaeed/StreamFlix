//
//  GetYoutubeSearchVideosUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 25/07/2025.
//

protocol GetYoutubeSearchVideosUseCase {
    func fetchVideos(query: String, completion: @escaping (Result<YoutubeSearchResponse, APIError>) -> Void)
}

class GetYoutubeSearchVideosUseCaseImpl: GetYoutubeSearchVideosUseCase {
    let youtubeRepository: YoutubeRepository
    init(youtubeRepository: YoutubeRepository = YoutubeRepositoryImpl()) {
        self.youtubeRepository = youtubeRepository
    }
    func fetchVideos(query: String, completion: @escaping (Result<YoutubeSearchResponse, APIError>) -> Void) {
        self.youtubeRepository.fetchVideos(query: query) { result in
            switch result {
            case .success(let youtubeSearchResponseVideos):
                completion(.success(youtubeSearchResponseVideos))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
}
