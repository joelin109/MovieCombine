import Foundation
import Combine


struct MovieService {
    
    static let shared = MovieService()
    
    private func searchMovieList(filter: String) -> AnyPublisher<ResponseModel<MovieModel>, HttpError> {
        
        let urlString = HttpManager.shared.getURLString(endpoint: .searchMovie, params: ["query": filter])
        
        let future = Future<ResponseModel<MovieModel>, HttpError> { promise in
            
            HttpManager.shared.requestWithResultCompletion(url: urlString){
                (result: Result<ResponseModel<MovieModel>, HttpError>) in
                switch result {
                case .success(let movies):
                    promise(.success(movies))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        
        return AnyPublisher(future)
    }
    
    private func showTopRatedMovies(filter: String) -> AnyPublisher<ResponseModel<MovieModel>, HttpError> {
        
        
        let future = Future<ResponseModel<MovieModel>, HttpError> { promise in
            
            Task {
                let movies = await HttpManager.shared.getMockData()
                promise(.success(movies!))
                
            }
            
        }
        
        return AnyPublisher(future)
    }
        
    private func fetchData(endpoint: Endpoint, params: [String: String]? = nil) -> AnyPublisher<ResponseModel<MovieModel>, HttpError> {
        
        let urlString = HttpManager.shared.getURLString(endpoint: endpoint, params: params)
        return HttpManager.shared.requestToPublisher(url: urlString)
        
    }
    
    
    func searchMovie(text: String) -> AnyPublisher<ResponseModel<MovieModel>, HttpError> {
        searchMovieList(filter: text)
    }
    
    func getTopRatedMovies(page: Int) -> AnyPublisher<ResponseModel<MovieModel>, HttpError> {
        showTopRatedMovies(filter: "")
        //fetchData(endpoint: .popular, params: ["page": "\(page)"])
    }
    
    func getNowPlaying(page: Int) -> AnyPublisher<ResponseModel<MovieModel>, HttpError> {
        fetchData(endpoint: .nowPlaying, params: ["page": "\(page)"])
    }
    
    func getUpcoming(page: Int) -> AnyPublisher<ResponseModel<MovieModel>, HttpError> {
        fetchData(endpoint: .upcoming, params: ["page": "\(page)"])
    }
    
}


