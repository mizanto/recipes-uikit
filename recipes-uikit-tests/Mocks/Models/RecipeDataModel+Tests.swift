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
            youtubeURL: nil,
            sourceURL: nil,
            ingredients: [],
            dateAdded: Date(),
            isFavorite: false
        )
    }
}
