//
//  NetworkService.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

import Foundation

protocol Service {
    func request(page: Int, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func requestSearch(page: Int, keyword: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class NetworkService: Service {

    private let urlString = "http://www.omdbapi.com/?s=friends&apikey="
    private let key = "656e3517" /// remove this key if wanna showing error state
    var query = "food"

    func request(page: Int, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {

        guard let url = URL(string: "\(urlString)\(key)")
        else { return }

        let task = createTask(url: url, completion: completion)
        task.resume()
    }

    func requestSearch(page: Int, keyword: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {

        guard let url = URL(string: "\(urlString)\(key)\(keyword)")
        else { return }

        let task = createTask(url: url, completion: completion)
        task.resume()
    }

    private func createTask(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask {

        return URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
    }
}
