//
//  MovieActorService.swift
//  ReactiveMovies
//
//  Created by Joe Lin on 14.09.22.
//  Copyright © 2022 Joe Lin. All rights reserved.
//

import Foundation
import Combine
//import Alamofire


struct MovieDetailService {
    
    static let shared = MovieDetailService()

    private func fetchDataToPub<AnyModel: Codable>(endpoint: Endpoint, params: [String: String]? = nil) -> AnyPublisher<AnyModel, HttpError> {
        
        let urlString = HttpManager.shared.getURLString(endpoint: endpoint, params: params)
        return HttpManager.shared.afRequestToPublisher(url: urlString)
        
    }
    
    
    func getMovieCredit(id: String) -> AnyPublisher<MovieCredit, HttpError> {
        return fetchDataToPub(endpoint: .movieCredit(id: id))
    }
    
    func getMovieVideos(id: String) -> AnyPublisher<Videos, HttpError> {
        return fetchDataToPub(endpoint: .movieVideos(id: id))
    }
    
}
