//
//  YoutubeRemoteDataSource.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 25/07/2025.
//
import Foundation

protocol YoutubeRemoteDataSource {
    func fetchVideos(query: String, completion: @escaping (Result<YoutubeSearchResponse, APIError>) -> Void)
}

class YoutubeRemoteDataSourceImpl: YoutubeRemoteDataSource {
    func fetchVideos(query: String, completion: @escaping (Result<YoutubeSearchResponse, APIError>) -> Void) {
        let apiRequest = GetYoutubeSearchRequest()
        apiRequest.queryItems?.append(URLQueryItem(name: "q", value: query))
        apiRequest.queryItems?.append(URLQueryItem(name: "key", value: Constants.youtubeAPIKEY))
        APICaller.shared.networkRequest(apiRequest: apiRequest, responseType: YoutubeSearchResponse.self) { result in
            switch result {
            case .success(let youtubeSearchResponseVideos):
                completion(.success(youtubeSearchResponseVideos))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
}
