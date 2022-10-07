//
//  ImageProvider.swift
//  MovieCombine
//
//  Created by Joe Lin on 17.09.22.
//

import SwiftUI
import Combine

class ImageLoaderViewModel: ObservableObject {
    @Published var image: UIImage?
    var imageUrl: String? = ""
    private var cancellable: AnyCancellable?
    private let imageLoader = ImageLoaderC()
    
    init(imagePath: String?, imageSize: ImageSizeEnum) {
        guard let imagePath = imagePath else{ return }
        let url = imageSize.pathUrl(path:imagePath)
        
        self.imageUrl = url.absoluteString
        self.load(url: url)
        
    }
    
    init(imageUrl: String? = "" ) {
        guard let url = URL(string: imageUrl!) else {
            return 
        }
        
        self.imageUrl = imageUrl!
        self.load(url: url)
        
    }
    
    func load(url: URL)  -> Void {
        
        Task {
            self.cancellable = await imageLoader.publisher(for: url)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(url.relativeString)
                        print(error)
                    }
                    
                }, receiveValue: { image in
                    //                    print(url.relativeString)
                    self.image = image
                })
            
            //            self.cancellable?.cancel()
        }
    }
    
}


class ImageLoaderC {

    private let urlSession: URLSession
    private let cache: NSCache<NSString, UIImage>

    init(urlSession: URLSession = .shared,
         cache: NSCache<NSString, UIImage> = .init()) {
        self.urlSession = urlSession
        self.cache = cache
    }

    func publisher(for url: URL) async -> AnyPublisher<UIImage, Error> {
        if let image = cache.object(forKey: url.relativeString as NSString) {
            return Just(image)
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return urlSession.dataTaskPublisher(for: url)
                .map(\.data)
                .tryMap { data in
                    guard let image = UIImage(data: data) else {
                        throw URLError(.badServerResponse, userInfo: [
                            NSURLErrorFailingURLErrorKey: url
                        ])
                    }
                    return image
                }
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput: { [cache] image in
                    cache.setObject(image, forKey: url.relativeString as NSString)
                })
                .eraseToAnyPublisher()
        }
    }
}




