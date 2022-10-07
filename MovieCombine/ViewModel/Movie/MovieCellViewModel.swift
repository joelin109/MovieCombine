//
//  MovieCellViewModel.swift
//  MovieCombine
//
//  Created by Joe Lin on 21.09.22.
//

import SwiftUI

class MovieCellViewModel: ObservableObject, Identifiable {
    var movie: MovieModel
    init(movie: MovieModel) {
        self.movie = movie
    }
}
