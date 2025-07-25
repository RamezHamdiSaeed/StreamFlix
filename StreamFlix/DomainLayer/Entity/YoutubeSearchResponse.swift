//
//  YoutubeSearchResponse.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 25/07/2025.
//

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
