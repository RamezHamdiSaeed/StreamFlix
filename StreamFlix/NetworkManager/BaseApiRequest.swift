//
//  BaseApiRequest.swift
//  StreamFlix
//
//  Created by Macbook on 17/07/2025.
//
import Foundation

class BaseApiRequest {
    let baseUrl: String
    let path: String
    var pathParams: [String: String]? = nil
    var queryItems: [URLQueryItem]? = nil
    var headers: [String: String]? = nil
    var body: Encodable? = nil
    var method: HTTPMethod = .GET
    
    init(baseUrl: String = Constants.baseURL, path: String) {
        self.baseUrl = baseUrl
        self.path = path
        self.queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey)]
    }
}
