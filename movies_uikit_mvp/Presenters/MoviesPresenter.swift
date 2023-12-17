import UIKit

protocol MoviesPresenter {
    init(apiProvider: ApiProvider, controller: MoviesVC)
    func fetchMovies()
    func fetchImg(path: String, cell: MoviesCell)
    var movies: Movies? { get set }
}

class MoviesPresenterImpl: MoviesPresenter{
    private let apiProvider: ApiProvider
    private let controller: MoviesVC
    var movies: Movies?

    required init(apiProvider: ApiProvider, controller: MoviesVC) {
        self.apiProvider = apiProvider
        self.controller = controller
    }

    func fetchMovies(){
        controller.showLoader()
        apiProvider.fetchMovies{ [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.movies = data
                    self?.controller.showMovies()
                case .failure(_):
                    self?.controller.showError()
                }
            }
        }
    }
    
    func fetchImg(path: String, cell: MoviesCell){
        apiProvider.fetchImg(path: path){ [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.controller.setImage(cell: cell, image: UIImage(data: data))
                case .failure(_):
                    self?.controller.setImage(cell: cell, image: UIImage(named: "not_found.png"))
                }
            }
        }
    }
}
