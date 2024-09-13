//
//  StorageError.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 13.09.2024.
//

import Foundation

enum StorageError: Error, LocalizedError {
    case itemNotFound
    case failedToFetch
    case failedToSave
    case failedToDelete
    case alreadyInFavorites
    case unknown

    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Item not found."
        case .failedToFetch:
            return "Failed to fetch items."
        case .failedToSave:
            return "Failed to save item."
        case .failedToDelete:
            return "Failed to delete item."
        case .alreadyInFavorites:
            return "Item is already in favorites."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
