//
//  OMDBEntity.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct OMDBEntity: Codable {
    let search: [Search]
    let totalResults, response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Search
struct Search: Codable {
    let title, year, imdbID: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case series = "series"
}

extension Search: Equatable {
    static func == (rhs: Search, lsh: Search) -> Bool {
        return lsh.imdbID == rhs.imdbID
    }
}

struct CacheImage: Decodable {
    let image: Data
    let url: String

    init(image: Data, url: String) {
        self.image = image
        self.url = url
    }

}

typealias CacheImages = [CacheImage]

struct OMDBViewModel {

    struct Cell: OMDBCellViewModel {
        var image: String
        var title: String
    }
    var cells: [Cell]

}
