//
//  MovieDetailHeader.swift
//  ReactiveMovies
//
//  Created by Joe Lin on 25/04/2020.
//  Copyright © 2020 Joe Lin. All rights reserved.
//

import SwiftUI
import Combine

//class MovieDetailHeaderValues {
//    var posterPosition: CGRect = .zero
//}

class MovieDetailHeaderViewModel: ObservableObject {
    
//    var releaseDate: String {
//        guard let productionDate = movie.releaseDate else {
//            return ""
//        }
//        let calendar = Calendar.current
//        return "(" + String(calendar.component(.year, from: productionDate)) + ")"
//    }
    
    @Published var trailer: Video?
    var posterPosition: CGRect = .zero
    private var subscriptions = Set<AnyCancellable>()
    let movie: MovieModel
    
    init(movie: MovieModel) {
        self.movie = movie
        
        self.fetchData()
    }
    
    func fetchData() {
        MovieDetailService.shared.getMovieVideos(id: String(movie.id))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { videos in
                self.trailer = videos.trailer
            })
            .store(in: &subscriptions)
    }
}

