//
//  RecipeDataModel+Tests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import Foundation

@testable import recipes_uikit

extension RecipeDataModel {
    static var mock: RecipeDataModel {
        RecipeDataModel(
            id: "1",
            mealName: "Test Meal",
            category: "Test Category",
            area: "Test Area",
            instructions: "Test instructions",
            mealThumbURL: URL(string: "https://example.com/image.jpg")!,
            youtubeURL: URL(string: "https://youtube.com/watch?v=test"),
            sourceURL: URL(string: "https://example.com/source"),
            ingredients: [Ingredient(name: "Chicken", measure: "200g")],
            dateAdded: Date(),
            isFavorite: false
        )
    }
}
