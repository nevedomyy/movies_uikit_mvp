import UIKit

protocol DetailsVC {
    func showLoader()
    func showDetails()
    func showError()
    func setImage(image: UIImage?)
}

class DetailsVCImpl: UIViewController, DetailsVC {
    private let detailsView: DetailsView
    private let id: Int
    
    var presenter: DetailsPresenter?
    
    init(detailsView: DetailsView, id: Int) {
        self.detailsView = detailsView
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailsView.errorButton.addTarget(self, action: #selector(fetchDetails), for: .touchUpInside)
        view = detailsView
        
        fetchDetails()
    }
    
    func showLoader() {
        detailsView.loaderView()
    }
    
    func showDetails() {
        detailsView.successView(
            title: presenter?.details?.title ?? "",
            raiting: "\(presenter?.details?.voteAverage ?? 0)",
            budget: "\(presenter?.details?.budget ?? 0)",
            descript: presenter?.details?.overview ?? ""
        )
    }
    
    func showError() {
        detailsView.errorView()
    }
    
    func setImage(image: UIImage?) {
        if image == nil { return }
        detailsView.image.image = image
    }
    
    @objc private func fetchDetails(){
        presenter?.fetchDetails(id: self.id)
    }
}
