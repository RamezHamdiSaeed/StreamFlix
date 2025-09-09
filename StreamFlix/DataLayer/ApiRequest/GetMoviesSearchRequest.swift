//
//  GetMoviesSearchRequest.swift
//  StreamFlix
//
//  Created by ramez Hamdy on 04/08/2025.
//
import Foundation

class GetMoviesSearchRequest: BaseApiRequest {
    var query: String? {
        didSet {
            self.queryItems?.append(URLQueryItem(name: "query", value: query ?? "a"))
        }
    }
    override init(baseUrl: String = Constants.baseURL, path: String = "/3/search/movie") {
        super.init(baseUrl: baseUrl, path: path)
    }
}
