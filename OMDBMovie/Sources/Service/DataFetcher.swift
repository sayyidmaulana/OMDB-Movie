//
//  DataFetcher.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

import Foundation

enum OMDBError: Error {
    case unableToComplete
    case invalidData
    case invalidResponse
}

protocol DataFetcher {
    func getOMDB(page: Int, completion: @escaping (Result<OMDBEntity, OMDBError>) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    private let service: Service

    init(service: Service) {
        self.service = service
    }

    func getOMDB(page: Int, completion: @escaping (Result<OMDBEntity, OMDBError>) -> Void) {
        service.request(page: page) { data, response, error in

            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            if let decode = self.decode(jsonData: OMDBEntity.self, from: data) {
                completion(.success(decode))
            }

        }
    }

    func searchOMDB(page: Int, keyword: String,
                        completion: @escaping (Result<OMDBEntity, OMDBError>) -> Void) {
        service.requestSearch(page: page, keyword: keyword, completion: { data, response, error in

            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            if let decode = self.decode(jsonData: OMDBEntity.self, from: data) {
                completion(.success(decode))
            }

        })
    }

    private func decode<T: Decodable>(jsonData type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()

        guard let data = data else { return nil }

        do {
            let response = try decoder.decode(type, from: data)
            return response
        } catch {
            print(error)
            return nil
        }
    }

}
