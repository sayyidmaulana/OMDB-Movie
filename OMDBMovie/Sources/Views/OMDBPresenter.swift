//
//  OMDBPresenter.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

import Foundation

protocol OMDBPresenterInput {
    var view: OMDBViewProtocol? { get set }
    var interactor: OMDBInteractorProtocol? { get set }
    var router: RouteModuleProtocol? { get set }
    var page: Int? { get set }
    var keyword: String? { get set }
    
    func viewDidLoad()
    func numberOfRowsInSection() -> Int
    func viewModel(at indexPath: IndexPath) -> OMDBViewModel.Cell
    func searchOMDB(page: Int, keyword: String)
    func fetchOMDB(page: Int)
    func updatePage(page: Int, keyword: String)
    func getDataImage(path: String, completion: @escaping (Data) -> Void)
}

protocol OMDBPresenterOutput: OMDBPresenterInput {
    func presentOMDB(data: OMDBViewModel)
    func presentError(message: String)
}

class OMDBPresenter {
    
    weak var view: OMDBViewProtocol?
    var interactor: OMDBInteractorProtocol?
    var router: RouteModuleProtocol?
    
    var page: Int? = 1
    var keyword: String? = ""
    
    func viewDidLoad() {
        view?.setupView()
        view?.setupCollection()
        view?.setupSearch()
        fetchOMDB(page: 1)
    }
    
    func fetchOMDB(page: Int) {
        interactor?.getOMDBData(page: page)
    }
    
    func numberOfRowsInSection() -> Int {
        interactor?.numberOfSection() ?? .zero
    }
    
    func viewModel(at indexPath: IndexPath) -> OMDBViewModel.Cell {
        interactor?.cellModel(at: indexPath) ?? OMDBViewModel.Cell(image: "", title: "")
    }
    
    func searchOMDB(page: Int, keyword: String) {
        interactor?.searchOMDB(page: page, keyword: keyword)
    }
    
    func updatePage(page: Int, keyword: String) {
        interactor?.updatePage(page: page, keyword: keyword)
    }
    
    func getDataImage(path: String, completion: @escaping (Data) -> Void) {
        interactor?.getImage(path: path, completion: completion)
    }
    
}

extension OMDBPresenter: OMDBPresenterOutput {
    func presentOMDB(data: OMDBViewModel) {
        if data.cells.isEmpty {
            view?.displayError(message: "There is no data shown right there!")
        } else {
            self.page = (self.page ?? 1) + 1
            view?.reloadOMDB()
        }
    }
    
    func presentError(message: String) {
        view?.displayError(message: message)
    }
}
