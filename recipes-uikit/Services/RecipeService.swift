//
//  RecipeService.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import Foundation

struct RecipeService {
    private let baseURL = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")!

    func fetchRandomRecipe() async throws -> Recipe {
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Response JSON String: \(jsonString)")
        } else {
            print("Unable to convert data to String")
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(RecipesResponse.self, from: data)
        
        guard let recipe = decodedResponse.meals.first else {
            throw URLError(.cannotParseResponse)
        }
        
        return recipe
    }
}
