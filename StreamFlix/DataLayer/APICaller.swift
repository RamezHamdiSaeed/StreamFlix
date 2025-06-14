import Foundation

struct Constants {
    static let baseURL = "https://api.themoviedb.org"
    static let apiKey = "10fc40366bdcc12b9f404656f2c75161"
}

enum APIError: Error {
    case invalidURL
    case network(Error)
    case noData
    case decoding(Error)
}

final class APICaller {
    static let shared = APICaller()
    private init() {}

    func getTrendingMovies(completion: @escaping ((Result<TrendingMovies, APIError>) -> Void)) {
        let urlString = "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle error
            if let error = error {
                completion(.failure(.network(error)))
                return
            }

            // Handle empty data
            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            // Debug raw JSON
            if let jsonString = String(data: data, encoding: .utf8) {
            }

            // Decode JSON
            do {
                let trendingMovies = try JSONDecoder().decode(TrendingMovies.self, from: data)
                completion(.success(trendingMovies))
            } catch {
                completion(.failure(.decoding(error)))
            }
        }
        
        task.resume()
    }
}
