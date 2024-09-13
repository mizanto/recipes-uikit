//
//  APIConfiguration.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

enum Endpoint {
    case randomRecipe

    var path: String {
        switch self {
        case .randomRecipe:
            return "random.php"
        }
    }
}

struct APIConfiguration {
    static let baseURL = "https://www.themealdb.com/api/json/v1/"
    static let apiKey = "1"

    static func url(for endpoint: Endpoint) -> URL? {
        return URL(string: "\(baseURL)\(apiKey)/\(endpoint.path)")
    }
}
