import UIKit

protocol MoviesVC {
    func showLoader()
    func showMovies()
    func showError()
    func setImage(cell: MoviesCell, image: UIImage?)
}

class MoviesVCImpl: UIViewController, MoviesVC {
    private let moviesView: MoviesView
    
    var presenter: MoviesPresenter?
    
    init(moviesView: MoviesView) {
        self.moviesView = moviesView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesView.tableView.dataSource = self
        moviesView.tableView.delegate = self
        moviesView.errorButton.addTarget(self, action: #selector(fetchMovies), for: .touchUpInside)
        view = moviesView
        
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = moviesView.tableView.indexPathForSelectedRow {
            moviesView.tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    func showLoader() {
        moviesView.loaderView()
    }
    
    func showMovies() {
        moviesView.successView()
    }
    
    func showError() {
        moviesView.errorView()
    }
    
    @objc private func fetchMovies(){
        presenter?.fetchMovies()
    }
}
        
extension MoviesVCImpl: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.movies?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: moviesView.identifier,
            for: indexPath) as? MoviesCell else {
            fatalError("Unsupported cell")
        }
        self.fetchImg(path: presenter?.movies?.results[indexPath.row].posterPath ?? "", cell: cell)
        cell.title.text = presenter?.movies?.results[indexPath.row].title ?? ""
        cell.descript.text = presenter?.movies?.results[indexPath.row].overview ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = presenter?.movies?.results[indexPath.row].id else { return }
        navigationController?.pushViewController(Dependencies.detailsVC(id: id), animated: true)
    }
    
    private func fetchImg(path: String, cell: MoviesCell){
        if path.isEmpty { return }
        presenter?.fetchImg(path: path, cell: cell)
    }
    
    func setImage(cell: MoviesCell, image: UIImage?) {
        if image == nil { return }
        cell.image.image = image
    }    
}
