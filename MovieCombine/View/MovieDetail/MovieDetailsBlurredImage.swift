import SwiftUI

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct MovieDetailsBlurredImage: View {
    
    @ObservedObject var imageLoader: ImageLoaderCViewModel
    
    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    Blur(style: .dark)
                }
                .clipped()
            } else {
                Rectangle()
                    .foregroundColor(.gray)
            }
        }
    }
}

#if DEBUG
class ImageLoaderMock: ImageLoaderCViewModel {
    init(image: UIImage) {
        super.init(imagePath: nil,imageSize: .small)
        self.image = image
    }
}

struct MovieDetailsBlurredImage_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsBlurredImage(imageLoader: ImageLoaderMock(image: UIImage(named: "parasite")!))
    }
}

struct MoviePosterImage_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
            MoviePosterImage(imageLoader: ImageLoaderMock(image: UIImage(named: "parasite")!))
        }
    }
}

struct MovieModelFactory {
    static func make(posterPath: String? = nil,
                     adult: Bool = false,
                     overview: String = "Overview",
                     releaseDateText: String = "2019-04-02",
                     genreIds: [Int] = [1],
                     id: Int = 123,
                     originalTitle: String = "Original Title",
                     originalLanguage: String =  "Original Language",
                     title: String = "Title",
                     backdropPath: String = "BackdropPath",
                     popularity: Float = 0,
                     voteCount: Int = 0,
                     video: Bool = false,
                     voteAverage: Float = 0) -> MovieModel {
        return MovieModel(posterPath: posterPath,
                          adult: adult,
                          overview: overview,
                          releaseDateText: releaseDateText,
                          genreIds: genreIds,
                          id: id,
                          originalTitle: originalTitle,
                          originalLanguage: originalLanguage,
                          title: title,
                          backdropPath: backdropPath,
                          popularity: popularity,
                          voteCount: voteCount,
                          video: video,
                          voteAverage: voteAverage)
    }
}
#endif
