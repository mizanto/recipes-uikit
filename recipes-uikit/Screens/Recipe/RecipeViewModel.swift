//
//  RecipeViewModel.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import Foundation

struct RecipeViewModel {
    let mealName: String
    let mealThumbURL: URL?
    let category: String?
    let area: String?
    let ingredients: String
    let instructions: String
    let isFavorite: Bool
    let onYoutubeButton: VoidHandler?
    let onSourceButton: VoidHandler?
}
