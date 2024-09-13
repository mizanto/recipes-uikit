//
//  NetworkError.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 13.09.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badServerResponse
    case unexpectedStatusCode(Int)
    case decodingError(Error)
    case networkError(Error)
    case noRecipeFound
}
