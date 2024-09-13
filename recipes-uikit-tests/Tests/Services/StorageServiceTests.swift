//
//  StorageServiceTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 13.09.2024.
//

import XCTest
import CoreData

@testable import recipes_uikit

class StorageServiceTests: XCTestCase {
    
    var storageService: StorageService!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        mockContext = setUpInMemoryManagedObjectContext()
        storageService = StorageService(context: mockContext)
    }
    
    override func tearDown() {
        storageService = nil
        mockContext = nil
        super.tearDown()
    }
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "Recipes")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("In-memory coordinator creation failed \(error)")
            }
        }
        return container.viewContext
    }
    
    func testSaveAndGetRecipe() throws {
        let recipe = RecipeDataModel(
            id: "1",
            mealName: "Test Meal",
            category: "Test Category",
            area: "Test Area",
            instructions: "Test Instructions",
            mealThumbURL: URL(string: "http://example.com/image.jpg")!,
            youtubeURL: URL(string: "http://youtube.com/example"),
            sourceURL: URL(string: "http://example.com"),
            ingredients: [Ingredient(name: "Ingredient1", measure: "1 cup")],
            dateAdded: Date(),
            isFavorite: false
        )
        
        // Save the recipe
        try storageService.saveRecipe(recipe)
        
        // Fetch the recipe by id
        let fetchedRecipe = try storageService.getRecipe(by: "1")
        
        // Assert that the fetched recipe matches the saved one
        XCTAssertEqual(fetchedRecipe.id, recipe.id)
        XCTAssertEqual(fetchedRecipe.mealName, recipe.mealName)
        XCTAssertEqual(fetchedRecipe.category, recipe.category)
        XCTAssertEqual(fetchedRecipe.area, recipe.area)
        XCTAssertEqual(fetchedRecipe.instructions, recipe.instructions)
        XCTAssertEqual(fetchedRecipe.mealThumbURL, recipe.mealThumbURL)
        XCTAssertEqual(fetchedRecipe.youtubeURL, recipe.youtubeURL)
        XCTAssertEqual(fetchedRecipe.sourceURL, recipe.sourceURL)
        XCTAssertEqual(fetchedRecipe.ingredients.count, recipe.ingredients.count)
        XCTAssertEqual(fetchedRecipe.dateAdded.timeIntervalSince1970, recipe.dateAdded.timeIntervalSince1970, accuracy: 1)
        XCTAssertEqual(fetchedRecipe.isFavorite, recipe.isFavorite)
    }
    
    // Test for getLastRecipe
    func testGetLastRecipe() throws {
        let recipe = RecipeDataModel(
            id: "1",
            mealName: "Test Meal",
            category: "Test Category",
            area: "Test Area",
            instructions: "Test Instructions",
            mealThumbURL: URL(string: "http://example.com/image.jpg")!,
            youtubeURL: URL(string: "http://youtube.com/example"),
            sourceURL: URL(string: "http://example.com"),
            ingredients: [Ingredient(name: "Ingredient1", measure: "1 cup")],
            dateAdded: Date(),
            isFavorite: false
        )
        
        try storageService.saveRecipe(recipe)
        
        let lastRecipe = try storageService.getLastRecipe()
        XCTAssertEqual(lastRecipe.id, recipe.id)
    }
    
    // Test for getRecipe(by:)
    func testGetRecipeById() throws {
        let recipe = RecipeDataModel(
            id: "1",
            mealName: "Test Meal",
            category: "Test Category",
            area: "Test Area",
            instructions: "Test Instructions",
            mealThumbURL: URL(string: "http://example.com/image.jpg")!,
            youtubeURL: URL(string: "http://youtube.com/example"),
            sourceURL: URL(string: "http://example.com"),
            ingredients: [Ingredient(name: "Ingredient1", measure: "1 cup")],
            dateAdded: Date(),
            isFavorite: false
        )
        
        try storageService.saveRecipe(recipe)
        
        let fetchedRecipe = try storageService.getRecipe(by: "1")
        XCTAssertEqual(fetchedRecipe.id, recipe.id)
    }
    
    // Test for getRecipeHistory
    func testGetRecipeHistory() throws {
        let historyItem = HistoryItemDataModel(id: "1", mealName: "Test Meal", date: Date())
        try storageService.saveRecipeToHistory(historyItem)
        
        let history = try storageService.getRecipeHistory()
        XCTAssertEqual(history.count, 1)
        XCTAssertEqual(history.first?.id, historyItem.id)
    }
    
    // Test for saveRecipeToHistory
    func testSaveRecipeToHistory() throws {
        let historyItem = HistoryItemDataModel(id: "1", mealName: "Test Meal", date: Date())
        try storageService.saveRecipeToHistory(historyItem)
        
        let fetchRequest: NSFetchRequest<HistoryItemEntity> = HistoryItemEntity.fetchRequest()
        let fetchedItems = try mockContext.fetch(fetchRequest)
        XCTAssertEqual(fetchedItems.count, 1)
        XCTAssertEqual(fetchedItems.first?.id, historyItem.id)
    }
    
    // Test for clearHistory
    func testClearHistory() throws {
        let historyItem = HistoryItemDataModel(id: "1", mealName: "Test Meal", date: Date())
        try storageService.saveRecipeToHistory(historyItem)
        
        try storageService.clearHistory()
        
        let fetchRequest: NSFetchRequest<HistoryItemEntity> = HistoryItemEntity.fetchRequest()
        let fetchedItems = try mockContext.fetch(fetchRequest)
        XCTAssertEqual(fetchedItems.count, 0)
    }
    
    // Test for getFavoriteRecipes
    func testGetFavoriteRecipes() throws {
        let recipe = RecipeDataModel(
            id: "1",
            mealName: "Test Meal",
            category: "Test Category",
            area: "Test Area",
            instructions: "Test Instructions",
            mealThumbURL: URL(string: "http://example.com/image.jpg")!,
            youtubeURL: URL(string: "http://youtube.com/example"),
            sourceURL: URL(string: "http://example.com"),
            ingredients: [Ingredient(name: "Ingredient1", measure: "1 cup")],
            dateAdded: Date(),
            isFavorite: true
        )
        
        try storageService.saveRecipe(recipe)
        
        let favoriteRecipes = try storageService.getFavoriteRecipes()
        XCTAssertEqual(favoriteRecipes.count, 1)
        XCTAssertEqual(favoriteRecipes.first?.id, recipe.id)
    }
    
    // Test for addRecipeToFavorites
    func testAddRecipeToFavorites() throws {
        let recipe = RecipeDataModel(
            id: "1",
            mealName: "Test Meal",
            category: "Test Category",
            area: "Test Area",
            instructions: "Test Instructions",
            mealThumbURL: URL(string: "http://example.com/image.jpg")!,
            youtubeURL: URL(string: "http://youtube.com/example"),
            sourceURL: URL(string: "http://example.com"),
            ingredients: [Ingredient(name: "Ingredient1", measure: "1 cup")],
            dateAdded: Date(),
            isFavorite: false
        )
        
        try storageService.saveRecipe(recipe)
        try storageService.addRecipeToFavorites(recipe)
        
        let favoriteRecipes = try storageService.getFavoriteRecipes()
        XCTAssertEqual(favoriteRecipes.count, 1)
        XCTAssertEqual(favoriteRecipes.first?.id, recipe.id)
    }
    
    // Test for removeRecipeFromFavorites
    func testRemoveRecipeFromFavorites() throws {
        let recipe = RecipeDataModel(
            id: "1",
            mealName: "Test Meal",
            category: "Test Category",
            area: "Test Area",
            instructions: "Test Instructions",
            mealThumbURL: URL(string: "http://example.com/image.jpg")!,
            youtubeURL: URL(string: "http://youtube.com/example"),
            sourceURL: URL(string: "http://example.com"),
            ingredients: [Ingredient(name: "Ingredient1", measure: "1 cup")],
            dateAdded: Date(),
            isFavorite: true
        )
        
        try storageService.saveRecipe(recipe)
        try storageService.removeRecipeFromFavorites(recipe)
        
        let favoriteRecipes = try storageService.getFavoriteRecipes()
        XCTAssertEqual(favoriteRecipes.count, 0)
    }
    
    // Test for isRecipeFavorite
    func testIsRecipeFavorite() throws {
        let recipe = RecipeDataModel(
            id: "1",
            mealName: "Test Meal",
            category: "Test Category",
            area: "Test Area",
            instructions: "Test Instructions",
            mealThumbURL: URL(string: "http://example.com/image.jpg")!,
            youtubeURL: URL(string: "http://youtube.com/example"),
            sourceURL: URL(string: "http://example.com"),
            ingredients: [Ingredient(name: "Ingredient1", measure: "1 cup")],
            dateAdded: Date(),
            isFavorite: true
        )
        
        try storageService.saveRecipe(recipe)
        
        let isFavorite = try storageService.isRecipeFavorite(recipe)
        XCTAssertTrue(isFavorite)
    }
}
