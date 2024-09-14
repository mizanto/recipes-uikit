//
//  MockNetworkService.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

class MockNetworkService: NetworkServiceProtocol {
    var randomRecipe: RecipeNetworkModel?
    var recipe: RecipeNetworkModel?
    var error: Error?
    
    func fetchRandomRecipe() async throws -> RecipeNetworkModel {
        if let error = error {
            throw error
        }
        guard let randomRecipe = randomRecipe else {
            throw URLError(.badServerResponse)
        }
        return randomRecipe
    }
    
    func fetchRecipe(id: String) async throws -> RecipeNetworkModel {
        if let error = error {
            throw error
        }
        guard let recipe = recipe else {
            throw URLError(.badServerResponse)
        }
        return recipe
    }
}
