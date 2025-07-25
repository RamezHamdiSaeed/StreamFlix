//
//  YoutubeRepositoryImpl.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 25/07/2025.
//

class YoutubeRepositoryImpl: YoutubeRepository {
    let youtubeRemoteDataSource: YoutubeRemoteDataSource
    init(youtubeRemoteDataSource: YoutubeRemoteDataSource = YoutubeRemoteDataSourceImpl()) {
        self.youtubeRemoteDataSource = youtubeRemoteDataSource
    }
    func fetchVideos(query: String, completion: @escaping (Result<YoutubeSearchResponse, APIError>) -> Void) {
        self.youtubeRemoteDataSource.fetchVideos(query: query) { result in
            switch result {
            case .success(let youtubeSearchResponseVideos):
                completion(.success(youtubeSearchResponseVideos))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
}
