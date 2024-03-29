//
//  OMDBInteractor.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

import Foundation

protocol OMDBInteractorProtocol {
    var presenter: OMDBPresenterOutput? { get set }
    
    func getOMDBData(page: Int)
    func searchOMDB(page: Int, keyword: String)
    func numberOfSection() -> Int
    func cellModel(at indexPath: IndexPath) -> OMDBViewModel.Cell
}

class OMDBInteractor: OMDBInteractorProtocol {
    var presenter: OMDBPresenterOutput?
    
    private var omdbViewModels = OMDBViewModel(cells: [])
    private var cacheImage: CacheImages?
    private let service = NetworkDataFetcher(service: NetworkService())
    
    func getOMDBData(page: Int) {
        service.getOMDB(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let omdb):
                let omdbItem = omdb.search.map { self.omdbViewModels(from: $0) }
                let omdbItemModel = OMDBViewModel(cells: omdbItem)
                self.omdbViewModels = omdbItemModel
                
                self.presenter?.presentOMDB(data: omdbItemModel)
            case .failure(let error):
                self.presenter?.presentError(message: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    
    func getImage(path: String, completion: @escaping (Data) -> Void) {
        if let url = URL(string: path) {
            if let imagedata = cacheImage?.filter({$0.url == path}).first {
                completion(imagedata.image)
            } else {
                let task = URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data, error == nil else { return }
                    self.cacheImage?.append(CacheImage(image: data, url: path))
                    completion(data)
                    return
                }

                task.resume()
            }
        } else {
            completion(Data())
        }
    }
    
    func searchOMDB(page: Int, keyword: String) {
        service.searchOMDB(page: page, keyword: keyword) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let omdb):
                let omdbItem = omdb.search.map { self.omdbViewModels(from: $0) }
                let omdbItemModel = OMDBViewModel(cells: omdbItem)
                self.omdbViewModels = omdbItemModel
                
                self.presenter?.presentOMDB(data: omdbItemModel)
            case .failure(let error):
                self.presenter?.presentError(message: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    
    func numberOfSection() -> Int {
        omdbViewModels.cells.count
    }
    
    func cellModel(at indexPath: IndexPath) -> OMDBViewModel.Cell { 
        omdbViewModels.cells[indexPath.row]
    }
}

extension OMDBInteractor {
    private func omdbViewModels(from omdbResult: Search) -> OMDBViewModel.Cell {
        return OMDBViewModel.Cell(image: omdbResult.poster, title: omdbResult.title)
    }
}
