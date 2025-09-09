import Foundation

struct Constants {
    static let baseURL = "https://api.themoviedb.org"
//    static let baseURL = "http://localhost:3001"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search"
    static let apiKey = "10fc40366bdcc12b9f404656f2c75161"
    static let youtubeAPIKEY = "AIzaSyCDJHusos1St8sitW60T0BPOhfK7Bv-vc0"
}

enum APIError: Error {
    case invalidPath
    case invalidURL
    case encoding(Error)
    case network(Error)
    case noData
    case decoding(Error)
    case noInternetConnection
    case timeout
    
    var localizedDescription: String {
        switch self {
        case .invalidPath:
            return "Invalid API path"
        case .invalidURL:
            return "Invalid URL"
        case .encoding(let error):
            return "Encoding error: \(error.localizedDescription)"
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .noData:
            return "No data received"
        case .decoding(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .timeout:
            return "Request timeout"
        case .noInternetConnection:
            return "No internet connection"
        }
    }
}

struct EmptyBody: Encodable {}

final class APICaller {

    static let shared = APICaller()
    private init() {}
    
    var sesion: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }
    
    private func buildURL(from apiRequest: BaseApiRequest) -> URL? {
        var pathWithParams = apiRequest.path
        apiRequest.pathParams?.forEach { key, value in
            pathWithParams = pathWithParams.replacingOccurrences(of: ":\(key)", with: value)
        }
        
        guard var components = URLComponents(string: "\(apiRequest.baseUrl)\(pathWithParams)") else {
            return nil
        }
        components.queryItems = apiRequest.queryItems
        return components.url
    }

    private func buildRequest(url: URL, from apiRequest: BaseApiRequest) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method.rawValue
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        apiRequest.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body = apiRequest.body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return nil
            }
        }
        
        return request
    }

    func networkRequest<T: Decodable>(apiRequest: BaseApiRequest,
                                      responseType: T.Type,
                                      completion: @escaping (Result<T, APIError>) -> Void) {
        
        print("🌐 Making network request to: \(apiRequest.path)")
        
        guard let url = buildURL(from: apiRequest) else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let request = buildRequest(url: url, from: apiRequest) else {
            completion(.failure(.encoding(NSError(domain: "Encoding error", code: 0))))
            return
        }
        
        let task = sesion.dataTask(with: request) { data, response, error in
            let context = NetworkResponseContext(data: data,
                                                 response: response,
                                                 error: error,
                                                 request: apiRequest)
            self.handleResponse(context: context, responseType: responseType, completion: completion)
        }
        
        task.resume()
    }
    
    private func handleResponse<T: Decodable>(context: NetworkResponseContext,
                                              responseType: T.Type,
                                              completion: @escaping (Result<T, APIError>) -> Void) {
        if let error = context.error {
            let nsError = error as NSError
            if nsError.code == NSURLErrorNetworkConnectionLost || nsError.code == NSURLErrorNotConnectedToInternet {
                completion(.failure(.noInternetConnection))
            } else if nsError.code == NSURLErrorTimedOut {
                completion(.failure(.timeout))
            } else {
                completion(.failure(.network(error)))
            }
            return
        }
        
        guard let httpResponse = context.response as? HTTPURLResponse else {
            completion(.failure(.network(NSError(domain: "Invalid response", code: 0))))
            return
        }
        
        if 200..<300 ~= httpResponse.statusCode {
            guard let data = context.data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decoding(error)))
            }
        } else {
            completion(.failure(.network(NSError(domain: "HTTP Error", code: httpResponse.statusCode))))
        }
    }

    struct NetworkResponseContext {
        let data: Data?
        let response: URLResponse?
        let error: Error?
        let request: BaseApiRequest
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
