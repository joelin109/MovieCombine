//
//  Created by Joe Lin on 15.09.22.
//  Copyright © 2022 Joe Lin. All rights reserved.
//

import Foundation
import Combine


extension HttpManager {
    
    func requestToPublisher<AnyModel: Codable>(url: String, params: [String: Any]? = nil) -> AnyPublisher<AnyModel, HttpError> {
        
        let urlRequest = URLRequest(url: URL(string:url)!)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                
                do {
                    
                    let dto = try JSONDecoder().decode(AnyModel.self, from: data)
                    return dto
                    
                } catch let error {
                    throw HttpError.jsonDecoding(error: error)
                }
                
            }
            .mapError { error in
                if let error = error as? HttpError {
                    return error
                } else {
                    return HttpError.error(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
        
    }
    
    
    func afRequestToPublisher<AndModel: Codable>(url: String, params: [String: Any]? = nil) -> AnyPublisher<AndModel, HttpError> {
        
        return HttpManager.shared.afRequest(url:url)
            .validate()
            .publishDecodable(type: AndModel.self)
            .value()
            .mapError { error in
                return HttpError.error(reason: error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
