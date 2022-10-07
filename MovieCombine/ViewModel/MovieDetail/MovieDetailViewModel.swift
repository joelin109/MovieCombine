//
//  MovieDetailViewModel.swift
//  ReactiveMovies
//
//  Created by Joe Lin on 13.09.22.
//  Copyright © 2022 Joe Lin. All rights reserved.
//

import SwiftUI
import Combine

class PosterPosition: ObservableObject {
    @Published var value: CGRect = .zero
}

class MovieDetailViewModel: ObservableObject {
    
    var viewFrame: CGRect = .zero
    var initialPosterPosition = CGRect.zero
    var movie: MovieModel
    @Published var castList: [CastModel] = []
    @ObservedObject var headerViewModel: MovieDetailHeaderViewModel
    @ObservedObject var imageLoaderViewModel: ImageLoaderViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(movie: MovieModel) {
        self.movie = movie
        self.headerViewModel = MovieDetailHeaderViewModel(movie: movie)
        self.imageLoaderViewModel = ImageLoaderViewModel(imagePath: movie.posterPath, imageSize: .medium)
    }
    
    func fetchData() {
        headerViewModel.fetchData()
        self.fetchMovieCredits(movieID: self.movie.id)
    }
    
    func fetchMovieCredits(movieID: Int) {
        MovieDetailService.shared.getMovieCredit(id: String(movieID))
            .receive(on: DispatchQueue.main)
            .replaceError(with: MovieCredit(id: 0, castList: [], crewList: []))
            .map { movieCredit in
                return movieCredit.castList.filter { $0.profilePath != nil }
            }
            .assign(to: \.castList, on: self)
            .store(in: &subscriptions)
    }
    
}


