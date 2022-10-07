import SwiftUI
import Combine


class MovieViewModel: ObservableObject {
    
    private var currentPage = 1
    private var subscriptions = Set<AnyCancellable>()
    private var fetchedMovies: [MovieModel] = []
    
    @Published var typedText: String = ""
    @Published var selectedCategoryIndex: Int = 2
    @Published var movieCellViewModels: [MovieCellViewModel] = []
    
    var isSearching: Bool {
        return typedText.count > 0
    }
    
    init() {
        
        $typedText
            .filter({ (value) -> Bool in
                if value.isEmpty {
                    //                    self.movieCellViewModels = self.fetchedMovies.map {
                    //                        MovieCellViewModel(movie: $0)
                    //                    }
                    return false
                }
                return true
            })
            .handleEvents(receiveOutput: { text in
                //                print(text)
            })
            .flatMap{ (item) -> AnyPublisher<ResponseModel<MovieModel>, HttpError> in
                return MovieService.shared.searchMovie(text: item)
            }
            .replaceError(with: ResponseModel<MovieModel>(page: nil, totalResults: nil, totalPages: nil, results: []))
            .receive(on: DispatchQueue.main)
            .map(\.results)
            .map { movies in
                return movies.map {MovieCellViewModel(movie: $0)}
            }
            .assign(to: \.movieCellViewModels, on: self)
            .store(in: &subscriptions)
        
        
        
        fetchMovieList(index: selectedCategoryIndex)
        
    }
    
    
    func fetchNextPage() {
        fetchMovies(index: selectedCategoryIndex, page: currentPage + 1)
    }
    
    func fetchMovieList(index: Int) {
        self.selectedCategoryIndex = index
        fetchMovies(index: selectedCategoryIndex, page: 1)
    }
    
    private func fetchMovies(index:Int, page: Int) {
        
        self.currentPage = page
        getSelectedCategoryMovies(index: index, page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print(" case .finished:")
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { response in
                self.currentPage = response.page ?? 0
                if self.currentPage <= 1 {
                    self.fetchedMovies  = []
                }
             
                let currentMovieIds = self.fetchedMovies.map { $0.id }
                self.fetchedMovies += response.results.filter { !currentMovieIds.contains($0.id) }
                self.movieCellViewModels = self.fetchedMovies.map {
                    return MovieCellViewModel(movie: $0) }
                
            })
            .store(in: &subscriptions)
    }
    
    
    private func getSelectedCategoryMovies(index: Int, page: Int) -> AnyPublisher<ResponseModel<MovieModel>, HttpError> {
        switch index {
        case 0:
            return MovieService.shared.getNowPlaying(page: page)
        case 1:
            return MovieService.shared.getUpcoming(page: page)
        default:
            return MovieService.shared.getTopRatedMovies(page: page)
        }
    }
    
}

