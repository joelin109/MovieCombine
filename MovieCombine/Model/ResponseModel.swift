//
//  Created by Joe Lin on 15.09.22.
//  Copyright © 2022 Joe Lin. All rights reserved.
//

import Foundation

struct ResponseModel<T: Codable>: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
