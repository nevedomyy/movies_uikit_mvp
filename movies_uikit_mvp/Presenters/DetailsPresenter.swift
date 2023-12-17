import UIKit

protocol DetailsPresenter {
    init(apiProvider: ApiProvider, controller: DetailsVC)
    func fetchDetails(id: Int)
    var details: Details? { get set }
}

class DetailsPresenterImpl: DetailsPresenter{
    private let apiProvider: ApiProvider
    private let controller: DetailsVC
    var details: Details?

    required init(apiProvider: ApiProvider, controller: DetailsVC) {
        self.apiProvider = apiProvider
        self.controller = controller
    }
    
    func fetchDetails(id: Int){
        controller.showLoader()
        apiProvider.fetchDetails(id: id){ [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.fetchImg(path: data.backdropPath)
                    self?.details = data
                    self?.controller.showDetails()
                case .failure(_):
                    self?.controller.showError()
                }
            }
        }
    }
    
    private func fetchImg(path: String){
        apiProvider.fetchImg(path: path){ [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.controller.setImage(image: UIImage(data: data))
                case .failure(_):
                    self?.controller.setImage(image: UIImage(named: "not_found.png"))
                }
            }
        }
    }
}
