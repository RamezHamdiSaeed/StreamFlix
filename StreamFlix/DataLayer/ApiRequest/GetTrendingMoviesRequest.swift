//
//  GetPopularMoviesRequest.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//
import Foundation

class GetTrendingMoviesRequest: BaseApiRequest {
    override init(baseUrl: String = Constants.baseURL, path: String = "/3/trending/movie/day") {
        super.init(baseUrl: baseUrl, path: path)
    }
}
