//
//  StoredRecipe.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import Foundation

struct StoredRecipe: Codable {
    let id: String
    let mealName: String
    let category: String?
    let area: String?
    let instructions: String
    let mealThumbURL: URL
    let tags: String?
    let youtubeURL: URL?
    let sourceURL: URL?
    var ingredients: [Ingredient]
    let dateAdded: Date
    
    init(from dto: RecipeDTO, dateAdded: Date = Date()) {
        self.id = dto.id
        self.mealName = dto.mealName
        self.category = dto.category
        self.area = dto.area
        self.instructions = dto.instructions
        self.mealThumbURL = dto.mealThumbURL
        self.tags = dto.tags
        self.youtubeURL = dto.youtubeURL
        self.sourceURL = dto.sourceURL
        self.ingredients = dto.ingredients
        self.dateAdded = dateAdded
    }
}
