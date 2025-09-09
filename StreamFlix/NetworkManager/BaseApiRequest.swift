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
    var pathParams: [String: String]?
    var queryItems: [URLQueryItem]?
    var headers: [String: String]?
    var body: Encodable?
    var method: HTTPMethod = .GET

    init(baseUrl: String = Constants.baseURL, path: String) {
        self.baseUrl = baseUrl
        self.path = path
        self.queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey)]
    }
}

extension BaseApiRequest {
    /* if there is networking request using parameters in the path
     we will add it here the centralize the value of each path parameter key*/
    enum RequestPathParametersKeys: String {
        case some = "Some"
    }
}
