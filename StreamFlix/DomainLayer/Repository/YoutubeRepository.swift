//
//  YoutubeRepository.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 25/07/2025.
//

protocol YoutubeRepository {
    func fetchVideos(query: String, completion: @escaping (Result<YoutubeSearchResponse, APIError>) -> Void)
}
