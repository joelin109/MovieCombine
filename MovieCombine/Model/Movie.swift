//
//  Created by Joe Lin on 08.09.22.
//  Copyright © 2022 Joe Lin. All rights reserved.
//

import Foundation

struct MovieModel: Codable, Identifiable {

    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDateText: String
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String?
    let popularity: Float
    let voteCount: Int
    let video: Bool
    let voteAverage: Float
    
    var releaseDate: Date? {
        return MovieModel.dateFormatter.date(from: releaseDateText)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter
    }()
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult, overview
        case releaseDateText = "release_date"
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}







