//
//  GetTrendingMoviesRequest.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//
import Foundation

class GetTrendingTVRequest: BaseApiRequest {
    override init(baseUrl: String = Constants.baseURL, path: String = "/3/trending/tv/day") {
        super.init(baseUrl: baseUrl, path: path)
        self.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
        self.queryItems?.append(URLQueryItem(name: "page", value: "1"))
    }
}
