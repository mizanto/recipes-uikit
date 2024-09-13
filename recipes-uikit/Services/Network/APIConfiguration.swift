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
    let baseURL: String
    let apiKey: String

    init(baseURL: String = "https://www.themealdb.com/api/json/v1/",
         apiKey: String = "1") {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }

    func url(for endpoint: Endpoint) -> URL? {
        let urlString = "\(baseURL)\(apiKey)/\(endpoint.path)"
        guard let url = URL(string: urlString), url.scheme == "https" else {
            return nil
        }
        return url
    }
}
