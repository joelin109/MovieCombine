//
//  APIService.swift
//  ReactiveMovies
//
//  Created by Joe Lin on 01/09/2022.
//  Copyright © 2022 Joe Lin. All rights reserved.
//

import Foundation


enum Endpoint {
    case popular
    case movieCredit(id: String)
    case movieVideos(id: String)
    case searchMovie
    case topRated
    case nowPlaying
    case upcoming
    
    var path: String {
        switch self {
        case .popular:
            return "movie/popular"
        case .topRated:
            return "movie/top_rated"
        case .movieCredit(let id):
            return "movie/\(id)/credits"
        case .movieVideos(let id):
            return "movie/\(id)/videos"
        case .searchMovie:
            return "/search/movie"
        case .nowPlaying:
            return "/movie/now_playing"
        case .upcoming:
            return "/movie/upcoming"
        }
    }
}

enum ImageSizeEnum: String {
    case small = "https://image.tmdb.org/t/p/w154/"
    case movie = "https://image.tmdb.org/t/p/w300/"
    case cast = "https://image.tmdb.org/t/p/w185/"
    case medium = "https://image.tmdb.org/t/p/w500/"
    case original = "https://image.tmdb.org/t/p/original/"
    
    func pathString(path: String) -> String {
        return URL(string: rawValue)!.appendingPathComponent(path).absoluteString
    }
    
    func pathUrl(path: String) -> URL {
        return URL(string: rawValue)!.appendingPathComponent(path)
    }
}


let baseURL = URL(string: "https://api.themoviedb.org/3")!
let key = "ed83110e61acf22eb89b8cf230506de8"


protocol HttpC {
    func getURLString(endpoint: Endpoint,params: [String: String]? ) -> String
}

extension HttpC {
   
    func getURLString(endpoint: Endpoint,params: [String: String]? = nil ) -> String {
        
        let queryURL = baseURL.appendingPathComponent(endpoint.path)
        guard var urlComponents = URLComponents(url: queryURL, resolvingAgainstBaseURL: true) else {
            return ""
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: key)
        ]
        
        if let params = params {
            for (_, value) in params.enumerated() {
                urlComponents.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        guard let url = urlComponents.url else {
            return ""
        }
        
        return url.absoluteString
    }
    
//    <T: Codable>
    func getMockData(isMock: Bool? = true ) async -> ResponseModel<MovieModel>? {
        
        guard let path = Bundle.main.path(forResource: "MockData-Fav", ofType: "json") else { return nil }
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let responseModel = try? JSONDecoder().decode(ResponseModel<MovieModel>.self, from: data!)
        
        return responseModel
    }
    
    
    func getMockMovie(isMock: Bool? = true, matchID:Int? = 718930 ) -> MovieModel? {
        
        guard let path = Bundle.main.path(forResource: "MockData-Fav", ofType: "json") else { return nil }
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let responseModel = try? JSONDecoder().decode(ResponseModel<MovieModel>.self, from: data!)
        
        let movies = responseModel!.results.filter { $0.id == matchID }
        return movies.count > 0 ? movies[0] : responseModel!.results[0]
    }
           
}
