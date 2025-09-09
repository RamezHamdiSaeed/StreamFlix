//
//  GetYoutubeSearchRequest.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 25/07/2025.
//

class GetYoutubeSearchRequest: BaseApiRequest {
    
    override init(baseUrl: String = Constants.youtubeBaseURL, path: String = "") {
        super.init(baseUrl: baseUrl, path: path)
    }
}
