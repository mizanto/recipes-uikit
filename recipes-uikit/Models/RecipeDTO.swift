//
//  RecipeDTO.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import Foundation

struct RecipeDTO: Codable {
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
        
        if let youtubeString = try container.decodeIfPresent(String.self, forKey: .youtubeURL),
           let url = URL(string: youtubeString) {
            youtubeURL = url
        } else {
            youtubeURL = nil
        }
        
        if let sourceString = try container.decodeIfPresent(String.self, forKey: .sourceURL),
           let url = URL(string: sourceString) {
            sourceURL = url
        } else {
            sourceURL = nil
        }
        
        var ingredients: [Ingredient] = []
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        for i in 1...20 {
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(i)")!
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)")!
            
            if let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey),
               let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey),
               !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ingredients.append(Ingredient(name: ingredient, measure: measure))
            }
        }
        self.ingredients = ingredients
    }
}

struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}
