//
//  RecipesResponse.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import Foundation

struct RecipesResponse: Codable {
    let meals: [RecipeNetworkModel]
}
