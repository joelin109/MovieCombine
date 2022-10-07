//
//  File.swift
//  MovieCombine
//
//  Created by Joe Lin on 30.09.22.
//
import SwiftUI

struct MovieDetailHeader: View {
    
    private var onTapPoster: ((CGRect) -> Void)?
    private let paddingLeading = 8.0
    
    @ObservedObject var viewModel: MovieDetailHeaderViewModel
    init(viewModel: MovieDetailHeaderViewModel, onTapPoster: ((CGRect) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onTapPoster = onTapPoster
    }
    
    var body: some View {
        
        HStack(alignment: .top) {
            
            VStack(alignment: .leading) {
                
                let imageWidth = UIScreen.screenWidth/2 - paddingLeading
                ExImageView(imageUrl: viewModel.movie.posterPath.imageUrl())
                    .frame(width: imageWidth, height: imageWidth * Cons.imageAspectRatio )
                    .cornerRadius(2)
                    .background(GeometryReader { reader in
                        assignValue(for: reader)
                    })
                    .onPreferenceChange(PosterFramePreferenceKey.self, perform: { position in
                        self.viewModel.posterPosition = position
                    }).onTapGesture {
                        onTapPoster?(self.viewModel.posterPosition)
                    }
                
                HStack(alignment: .top) {
                    RatingView(percent: viewModel.movie.voteAverage * 10)
                    VStack(alignment: .leading) {
                        Spacer()
                        Text("Users Score")
                            .foregroundColor(.exGruen)
                            .font(Font.caption.bold())
                    }
                    .frame(height: 20)
                    
                }.offset(x:0,y:-5)
                
                
                if let movieTrailer = viewModel.trailer {
                    
                    HStack {
                        
                        Link(destination: URL(string: movieTrailer.key.toYouTubeUrl())!,
                             label: {
                            Image(systemName: "play.fill")
                                .font(.system(size: 22).bold())
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36, height: 36)
                                .foregroundColor(.exWeiss )
                        })
                        
                    }
                    .background(Color.exRot.opacity(0.9))
                    .cornerRadius(22)
                    .offset(x:135,y:-30)
                    .frame(height: 0)
                    
                } // End of if let
                
            } // End of VStack
            
            
            VStack(alignment: .leading) {
                Text(viewModel.movie.title)
                    .font(Font.title2.bold())
                    .foregroundColor(.exSchwarz)
                    .frame(minHeight: 30)
                Divider()
                Text("Overview")
                    .foregroundColor(.exBraun)
                    .font(Font.subheadline.bold())
                    .frame(height: 20)
                
                Text(viewModel.movie.overview)
                    .foregroundColor(.exSchwarz)
                    .font(Font.caption)
                    .lineLimit(13)
                
                
            }
//            Spacer()
            
            
        }
        .padding(EdgeInsets(top: 15, leading: paddingLeading, bottom: 5, trailing: 3))
        .background(Color.white)
        
    }
    
    
    private func assignValue(for reader: GeometryProxy) -> some View {
        let frame = reader.frame(in: .named("MovieDetails.main"))
        self.viewModel.posterPosition = frame
        return Color.clear.preference(key: PosterFramePreferenceKey.self, value: frame)
    }
    
}


struct PosterFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

struct MovieDetailHeader_Previews: PreviewProvider {
    
    static let movie = HttpManager.shared.getMockMovie(matchID: 756999)!
    static var previews: some View {
        MovieDetailHeader(viewModel: MovieDetailHeaderViewModel(movie: movie))
    }
    
}
