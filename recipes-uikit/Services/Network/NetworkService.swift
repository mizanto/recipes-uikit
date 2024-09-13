//
//  NetworkService.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchRandomRecipe() async throws -> RecipeNetworkModel
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    private func fetchData<T: Decodable>(from url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                AppLogger.shared.debug("Response JSON String: \(jsonString)", category: .network)
            } else {
                AppLogger.shared.error("Unable to convert data to String", category: .network)
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                AppLogger.shared.error("Failed to cast response to HTTPURLResponse", category: .network)
                throw NetworkError.badServerResponse
            }

            guard httpResponse.statusCode == 200 else {
                AppLogger.shared.error("Unexpected HTTP status code: \(httpResponse.statusCode)", category: .network)
                throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch let decodingError as DecodingError {
            AppLogger.shared.error("Decoding error: \(decodingError.localizedDescription)", category: .network)
            throw NetworkError.decodingError(decodingError)
        } catch {
            AppLogger.shared.error("Network error: \(error.localizedDescription)", category: .network)
            throw NetworkError.networkError(error)
        }
    }

    func fetchRandomRecipe() async throws -> RecipeNetworkModel {
        guard let url = APIConfiguration.url(for: .randomRecipe) else {
            AppLogger.shared.error("Failed to construct URL for random recipe", category: .network)
            throw NetworkError.badURL
        }

        let decodedResponse: RecipesResponse = try await fetchData(from: url)

        guard let recipe = decodedResponse.meals.first else {
            AppLogger.shared.error("Failed to parse recipe from response", category: .network)
            throw NetworkError.noRecipeFound
        }
        
        return recipe
    }
}
