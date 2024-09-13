//
//  NetworkError.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 13.09.2024.
//

import Foundation

enum NetworkError: Error, Equatable, LocalizedError {
    case badURL
    case badServerResponse
    case unexpectedStatusCode(Int)
    case decodingError(Error)
    case networkError(Error)
    case noRecipeFound

    // Equatable conformance
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.badURL, .badURL),
             (.badServerResponse, .badServerResponse),
             (.noRecipeFound, .noRecipeFound):
            return true
        case (.unexpectedStatusCode(let lhsCode), .unexpectedStatusCode(let rhsCode)):
            return lhsCode == rhsCode
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        default:
            return false
        }
    }

    // LocalizedError conformance
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL provided was invalid."
        case .badServerResponse:
            return "The server response was invalid."
        case .unexpectedStatusCode(let statusCode):
            return "Received an unexpected status code: \(statusCode)."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)."
        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription)."
        case .noRecipeFound:
            return "No recipe was found in the response."
        }
    }
}
