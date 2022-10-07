//
//  Created by Joe Lin on 14.09.22.
//  Copyright © 2022 Joe Lin. All rights reserved.
//

import Foundation


struct MovieCredit: Codable {
    let id: Int
    let castList: [CastModel]
    let crewList: [CrewModel]
    
    enum CodingKeys: String, CodingKey {
        case castList = "cast"
        case crewList = "crew"
        case id
    }
}


struct CastModel: Codable, Identifiable {
    let castID: Int
    let character: String
    let creditID: String
    let gender: Int
    let id: Int
    let name: String
    let order: Int
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case gender, id, name, order
        case profilePath = "profile_path"
    }
}

struct CrewModel: Codable {
    let creditID: String
    let department: String
    let gender: Int
    let id: Int
    let job: String
    let name: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case creditID = "credit_id"
        case department, gender, id, job, name
        case profilePath = "profile_path"
    }
}
