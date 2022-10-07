//
//  ExString.swift
//  MovieCombine
//
//  Created by Joe Lin on 03.10.22.
//

//import Foundation

extension Optional where Wrapped == String  {
    func imageUrl(imageSize: ImageSizeEnum? = ImageSizeEnum.movie) -> String {
        if self == nil {
            return ""
        }
        
        return imageSize!.pathString(path:self!)
    }
    
}

extension String  {
    func toYouTubeUrl() -> String {
    
        return "https://www.youtube.com/watch?v=\(self)"
    }
}
