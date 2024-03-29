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
    private let keyword = "friends"
    private let key = "656e3517" /// remove this key if wanna showing error state

    func request(page: Int, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {

        var components = URLComponents()
            components.scheme = "http"
            components.host = "www.omdbapi.com"
            components.queryItems = [
                URLQueryItem(name: "s", value: keyword),
                URLQueryItem(name: "apikey", value: key)
            ]
        
        guard let url = components.url
        else { return }

        let task = createTask(url: url, completion: completion)
        task.resume()
    }

    func requestSearch(page: Int, keyword: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {

        var components = URLComponents()
            components.scheme = "http"
            components.host = "www.omdbapi.com"
            components.queryItems = [
                URLQueryItem(name: "s", value: keyword),
                URLQueryItem(name: "apikey", value: key)
            ]
        
        guard let url = components.url
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
