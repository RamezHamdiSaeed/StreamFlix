import Foundation

struct Constants {
    static let baseURL = "https://api.themoviedb.org"
//    static let baseURL = "http://localhost:3000"
    static let apiKey = "YOUR_API_KEY_HERE"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
}

enum APIError: Error {
    case invalidPath
    case invalidURL
    case encoding(Error)
    case network(Error)
    case noData
    case decoding(Error)
}

struct EmptyBody: Encodable{}

final class APICaller {
    
    static let shared = APICaller()
    private init() {}

    func networkRequest<T: Decodable>(apiRequest: BaseApiRequest ,responseType: T.Type, completion: @escaping ((Result<T, APIError>) -> Void)) {
        
        var pathWithParams = apiRequest.path
        if let params = apiRequest.pathParams {
            params.forEach{ key, value in
                pathWithParams = pathWithParams.replacingOccurrences(of: ":\(key)", with: value)
            }
        }
        
        guard var urlComponents = URLComponents(string: "\(apiRequest.baseUrl)\(pathWithParams)") else {
            completion(.failure(.invalidPath))
            return
        }
        
        urlComponents.queryItems = apiRequest.queryItems
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRequest.method.rawValue
        
        if let headers = apiRequest.headers {
            headers.forEach{ key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = apiRequest.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(.encoding(error)))
                return
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
                completion(.failure(.network(error)))
                return
            }
            if let response = response as? HTTPURLResponse {
                if 200..<300 ~= response.statusCode {
                    if let data {
                        do {
                            let responseData = try JSONDecoder().decode(responseType,from: data)
                            completion(.success(responseData))
                        } catch {
                            completion(.failure(.decoding(error)))
                            return
                        }
                    } else {
                        completion(.failure(.noData))
                    }
                } else {
                    completion(.failure(.network(NSError(domain: "something went wrong", code: 0))))
                }
            }
            
        }.resume()
        
    }
    
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
