//
//  NetworkService.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchRandomRecipe() async throws -> RecipeDTO
}

struct NetworkService: NetworkServiceProtocol {
    
    private let baseURL = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")!
    
    private func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Response JSON String: \(jsonString)")
        } else {
            print("Unable to convert data to String")
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func fetchRandomRecipe() async throws -> RecipeDTO {
        guard let url = APIConfiguration.url(for: .randomRecipe) else {
            throw URLError(.badURL)
        }
        
        let decodedResponse: RecipesResponse = try await fetchData(from: url)
        
        guard let recipe = decodedResponse.meals.first else {
            throw URLError(.cannotParseResponse)
        }
        
        return recipe
    }
}
