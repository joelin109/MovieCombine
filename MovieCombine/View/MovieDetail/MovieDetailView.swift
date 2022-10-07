import SwiftUI

struct MovieDetails: View {
    
    let frameName = "MovieDetails.main"
    @State var isShowingContent = false
    @State var startPosterAnimation = false
    @State var isPosterAnimating = false
    @State var posterStartPosition = CGRect.zero
    @State var posterEndPosition = CGRect.zero
    @State var posterPosition = CGRect.zero
    
    @ObservedObject var viewModel: MovieDetailViewModel
    
    init(movie: MovieModel) {
        self.viewModel = MovieDetailViewModel(movie: movie)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            ScrollView {
                if isShowingContent {
                    MovieDetailHeader(viewModel: viewModel.headerViewModel) { posterPosition in
                        
                        viewModel.initialPosterPosition = posterPosition
                        self.posterPosition = posterPosition
                        
                        let width = viewModel.viewFrame.width - 16
                        let height = width * Cons.imageAspectRatio
                        withAnimation(.easeInOut(duration: 0.6)) {
                            isPosterAnimating = true
                            self.posterPosition =  CGRect(x: viewModel.viewFrame.minX + 8, y: viewModel.viewFrame.minY + 15, width: width, height: height)
                        }
                        
                    }
                    
                    
                    CastListView(viewModel: viewModel)
                    
                }
                
            }
            .background(Color.exGrau)
            
            
            MoviePosterImageView(
                imageLoader: viewModel.imageLoaderViewModel,
                pct: isPosterAnimating ? 1 : 0, frame: posterPosition
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.6)) {
                    posterPosition = viewModel.initialPosterPosition
                    isPosterAnimating = false
                }
            }
            
            
        }
        .background(Color.exBlau)
        .background(GeometryReader { geometry in
            assignViewFrame(geometry: geometry)
        })
        .coordinateSpace(name: frameName)
        .navigationBarTitle(viewModel.movie.title, displayMode: .inline)
        
        .onAppear {
            self.isShowingContent = true
            viewModel.fetchData()
        }
    }
        
    
    
    private func assignViewFrame(geometry: GeometryProxy) -> some View {
        viewModel.viewFrame = geometry.frame(in: .named(frameName))
        return Color.yellow.preference(key: MovieDetailsPreferenceKey.self, value: viewModel.viewFrame)
    }
    
}

struct MovieDetailsPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { }
}


struct MovieDetails_Previews: PreviewProvider {

    static let movie = HttpManager.shared.getMockMovie(matchID: 787)!
//    static let movie = MovieModel(posterPath:  "/tVxDe01Zy3kZqaZRNiXFGDICdZk.jpg", adult: false, overview: "Unlucky assassin Ladybug is determined to do his job peacefully after one too many gigs gone off the rails. Fate, however, may have other plans, as Ladybug's latest mission puts him on a collision course with lethal adversaries from around the globe—all with connected, yet conflicting, objectives—on the world's fastest train.", releaseDateText: "2022-07-03", genreIds: [28,35,53], id: 718930, originalTitle:  "Bullet Train", originalLanguage: "en", title: "Bullet Train", backdropPath:  "/C8FpZfTPEZDjngPlatiFsaDB4A.jpg", popularity: 2897.045, voteCount: 988, video: false, voteAverage: 7.4)
    static var previews: some View {
        MovieDetails(movie: movie)
    }
    
  
}


