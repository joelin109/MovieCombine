//
//  Created by Joe Lin on 01/09/2022.
//  Copyright © 2022 Joe Lin. All rights reserved.
//

import Foundation
import Alamofire


enum HttpError: Error, LocalizedError {
    case urlComponentsCreation
    case urlComponentURLCreation
    case emptyResponse
    case response(error: Error)
    case jsonDecoding(error: Error)
    case unknown
    case error(reason: String)
}


struct HttpManager:HttpC {
    
    static let shared = HttpManager()
    let decoder = JSONDecoder()
    
    
    // Default Request
    /*
     url --> İstek atılacak URL
     method --> İstek atılan metodun tipini veriyoruz (Örn.: GET, POST)
     params --> İstek atılan metoda body içerisinde göndereceğimiz parametrelemerimiz
     */
    private func getDefaultRequest(url: String,
                                   method: HTTPMethod,
                                   params: [String: AnyObject] = [:]) -> URLRequest {
        
        var request = URLRequest(url: URL(string: url)!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData // -> Cache politikası
        request.timeoutInterval = 120.0 // -> İstek zaman aşımı
        request.method = method
        if(!params.isEmpty) { // -> Eğer bu fonksiyona bir parametre gönderiliyorsa bunu body içerisine ekliyoruz.
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        return request
    }
    
    
    func requestWithResultCompletion<AnyModel: Codable>(url: String, withBody body: Data? = nil,
                                        completion: @escaping (Result<AnyModel, HttpError>) -> Void) {
        
        let request = URLRequest(url: URL(string:url)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.emptyResponse))
                }
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.response(error: error)))
                }
                return
            }
            
            do {
                let dto = try self.decoder.decode(AnyModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dto))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.jsonDecoding(error: error)))
                }
            }
            
        }
        task.resume()
    }
    
    
    func afRequestWithResultCompletion<AnyModel: Codable>(url: String, withBody body: Data? = nil,
                                                            completion: @escaping (Result<AnyModel, HttpError>) -> Void) {
        
        let request = self.getDefaultRequest(url: url, method: .get)
        
        AF.request(request).responseData { (httpResponse ) in
            do {
                switch httpResponse.result {
                case .success:
                    let _responseModel = try JSONDecoder().decode(AnyModel.self, from: httpResponse.data!)
                    DispatchQueue.main.async {
                        completion(.success(_responseModel))
                    }
                    //                    let dict = try? JSONSerialization.jsonObject(with: httpResponse.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
                    //                    let responseModel = try? JSONDecoder().decode(ResponseModel<MovieModel>.self, from: httpResponse.data!)
                case .failure(let error):
                    completion(.failure(.jsonDecoding(error: error)))
                }
                
            } catch let error {
                completion(.failure(.jsonDecoding(error: error)))
            }
        }
        
    }
    
    
    func afRequest(url:String) -> DataRequest {
        let request = self.getDefaultRequest(url: url, method: .get)
        return AF.request(request)
    }
    

}
