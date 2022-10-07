//
//  MovieCastView.swift
//  MovieCombine
//
//  Created by Joe Lin on 01.10.22.
//

import SwiftUI

struct CastCellView: View {
    
    var cast: CastModel
    init(cast: CastModel) {
        self.cast = cast
    }
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading) {
                //                ExImageView(imageUrl: viewModel.castImageUrl)
                ExImageLoader(imageUrl: cast.profilePath.imageUrl())
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(cast.name)
                        .foregroundColor(.black)
                        .font(.system(size: 10)).bold()
                    Text(cast.character)
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                }
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                .frame(height: 1/4 * reader.size.height)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.3), radius: 6)
        }
    }
}

struct CastListView: View {
    
    let layout = [ GridItem(.adaptive(minimum: 85), spacing: 10) ]
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        
        LazyVGrid(columns: layout, spacing: 10) {
            ForEach(self.viewModel.castList) { cast in
                
                return CastCellView(cast: cast)
                    .frame(minHeight: 180)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
   
        
        
    }
    
    private func getProperElementFrame(reader: GeometryProxy) -> CGRect {
        let elementsOnScreen = 4
        let spacing: CGFloat = 5
        let padding = EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8)
        let elementWidth  = (reader.size.width - (CGFloat(elementsOnScreen - 1) * spacing)) / (CGFloat(elementsOnScreen) - 0.5)
        let elementHeight = reader.size.height - padding.top - padding.bottom
        return CGRect(x: 0, y: 0, width: elementWidth, height: elementHeight)
    }
}

struct CastListView_Previews: PreviewProvider {
    
    static let movie = HttpManager.shared.getMockMovie(matchID: 787)!
    static var previews: some View {
        
        ScrollView {
            CastListView(viewModel: MovieDetailViewModel(movie: movie))
        }
    }
    
}
