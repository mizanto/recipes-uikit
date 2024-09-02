//
//  Recipe.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import Foundation

struct Recipe: Codable {
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

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case mealName = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case mealThumbURL = "strMealThumb"
        case tags = "strTags"
        case youtubeURL = "strYoutube"
        case sourceURL = "strSource"
        case ingredients = "strIngredient1"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        mealName = try container.decode(String.self, forKey: .mealName)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        area = try container.decodeIfPresent(String.self, forKey: .area)
        instructions = try container.decode(String.self, forKey: .instructions)
        mealThumbURL = try container.decode(URL.self, forKey: .mealThumbURL)
        tags = try container.decodeIfPresent(String.self, forKey: .tags)
        youtubeURL = try container.decodeIfPresent(URL.self, forKey: .youtubeURL)
        sourceURL = try container.decodeIfPresent(URL.self, forKey: .sourceURL)

        var ingredients: [Ingredient] = []
        for i in 1...20 {
            let ingredientKey = CodingKeys(rawValue: "strIngredient\(i)")!
            let measureKey = CodingKeys(rawValue: "strMeasure\(i)")!
            if let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey),
               let measure = try container.decodeIfPresent(String.self, forKey: measureKey),
               !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ingredients.append(Ingredient(name: ingredient, measure: measure))
            }
        }
        self.ingredients = ingredients
    }
}
