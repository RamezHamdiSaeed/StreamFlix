//
//  GetTopRatedMoviesRequest.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 20/07/2025.
//
import Foundation

class GetTopRatedMoviesRequest: BaseApiRequest {
    override init(baseUrl: String = Constants.baseURL, path: String = "/3/movie/top_rated") {
        super.init(baseUrl: baseUrl, path: path)
        self.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
        self.queryItems?.append(URLQueryItem(name: "page", value: "1"))
    }
}
