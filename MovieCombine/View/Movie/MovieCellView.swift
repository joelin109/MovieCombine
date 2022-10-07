import SwiftUI

struct MovieCellView: View {
    @State private var cellHeight: CGFloat = 180
    @ObservedObject var viewModel: MovieCellViewModel
    init(viewModel: MovieCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .ratingAndPosterAlignment) {
            VStack(alignment: .leading, spacing: 0) {
                ExImageView(imageUrl: self.viewModel.movie.posterPath.imageUrl())
//                ExImageLoader(imageUrl: self.viewModel.movieImageUrl)
                    .frame(height: cellHeight)
                
                VStack(alignment:  .leading, spacing: 4) {
                    Text(viewModel.movie.title)
                        .foregroundColor(.black)
                        .font(.system(size: 11)).bold()
                        .lineLimit(2)
                        .alignmentGuide(.top, computeValue: { d in return 27 })
                    
                    Text(viewModel.movie.releaseDate?.toMoviePosterDateString() ?? "")
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                        .alignmentGuide(.top, computeValue: { d in return 0 })
                }
//                .frame(minHeight: 40)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 8, trailing: 2))
                
                
            }
            .background(GeometryReader { reader in
                
//                Color.white.preference(key: WidthKey.self, value: reader.size.width)
                
            })
            .cornerRadius(3)
            .shadow(color: Color.gray.opacity(0.2), radius: 1)
            
            
            
            RatingView(percent: viewModel.movie.voteAverage * 10, animate: false)
                .offset(x:83,y:-8)
            
        }
    }
}

struct DateFormatters {
    static let moviePosterDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter
    }()
}

extension Date {
    func toMoviePosterDateString() -> String {
        DateFormatters.moviePosterDateFormatter.string(from: self)
    }
}

extension VerticalAlignment {
    enum RatingAndPoster: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }

    static let ratingAndPosterVerticalAlignment = VerticalAlignment(RatingAndPoster.self)
}

extension HorizontalAlignment {
    enum RatingAndPoster: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }

    static let ratingAndPosterHorizontalAlignment = HorizontalAlignment(RatingAndPoster.self)
}

extension Alignment {
    static let ratingAndPosterAlignment = Alignment(horizontal: .ratingAndPosterHorizontalAlignment, vertical: .ratingAndPosterVerticalAlignment)
}


//
//private extension VerticalAlignment {
//    enum RatingAndPoster: AlignmentID {
//        static func defaultValue(in context: ViewDimensions) -> CGFloat {
//            context[.top]
//        }
//    }
//
//    static let ratingAndPosterVerticalAlignment = VerticalAlignment(RatingAndPoster.self)
//}
//
//private extension HorizontalAlignment {
//    enum RatingAndPoster: AlignmentID {
//        static func defaultValue(in context: ViewDimensions) -> CGFloat {
//            context[.leading]
//        }
//    }
//
//    static let ratingAndPosterHorizontalAlignment = HorizontalAlignment(RatingAndPoster.self)
//}
//
//private extension Alignment {
//    static let ratingAndPosterAlignment = Alignment(horizontal: .ratingAndPosterHorizontalAlignment, vertical: .ratingAndPosterVerticalAlignment)
//}

//struct MovieView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            MovieView(movie: MovieModelFactory.make()).frame(width: 100, height: 250)
//        }
//    }
//}
