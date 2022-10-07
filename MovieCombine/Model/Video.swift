//
//  Created by Joe Lin on 14.09.22.
//  Copyright © 2022 Joe Lin. All rights reserved.
//

import Foundation

struct Videos: Codable {
    let id: Int
    let results: [Video]
    
    var trailer: Video? { results.first { $0.type == .trailer }}
}

struct Video: Codable {
    enum `Type`: String, Codable {
        case trailer = "Trailer"
        case unknown
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            self = Self(rawValue: value) ?? .unknown
        }
    }
    let id, key: String
    let name, site: String
    let size: Int
    let type: Type
}
