import SwiftUI

struct Cons {
    static let imageAspectRatio: CGFloat = 1.5
}

struct ExImageView: View {
    @ObservedObject var imageLoader: ImageLoaderViewModel
    init(imageUrl: String) {
        self.imageLoader = ImageLoaderViewModel(imageUrl: imageUrl)
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: reader.size.width, height: reader.size.height)
                } else {
                    Rectangle().foregroundColor(.white)
                    
                    ZStack(alignment: .center) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color.exGrau)
                    }
                }
            }
//            .clipped()
        }
    }
}

struct ExImageLoader: View {
    
    @State private var imageUrl: String
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
   
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                
                AsyncImage(url: URL(string: self.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: reader.size.width, height: reader.size.height)
                    
                } placeholder: {
                    Rectangle().foregroundColor(.white)
                    
                    VStack(alignment: .center) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color.exGrau)
                        
                        Spacer()
                    }
                    
                }
                
            }
        }
    }
    
    
}
