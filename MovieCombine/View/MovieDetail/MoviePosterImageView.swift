import SwiftUI

struct MoviePosterImageView: View {
   
    let pct: Double
    let frame: CGRect
    @ObservedObject var imageLoader: ImageLoaderViewModel
    init(imageLoader: ImageLoaderViewModel, pct: Double, frame: CGRect) {
//        self.imageLoader = ImageLoaderViewModel(imageUrl: imageLoader.imageUrl)
//        self.imageLoader = ImageLoaderViewModel(imagePath: movie.posterPath, imageSize: .medium)
        self.imageLoader = imageLoader
        self.pct = pct
        self.frame = frame
    }
    
    struct MoviePosterModifier: AnimatableModifier {
        var pct: CGFloat
        var frame: CGRect
        
        var animatableData: CGFloat {
            get { pct }
            set { pct = newValue }
        }
        
        func body(content: Content) -> some View {
            content
                .frame(width: frame.width, height: frame.height)
                .offset(x: frame.minX, y: frame.minY)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: frame.minY, trailing: frame.minX))
                .clipped()
                .aspectRatio(contentMode: .fit)
                .opacity((pct == 0) ? 0 : 1)
        }
    }
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } else {
                EmptyView()
            }
        }
        .modifier(MoviePosterModifier(pct: CGFloat(pct), frame: frame))
    }
}

