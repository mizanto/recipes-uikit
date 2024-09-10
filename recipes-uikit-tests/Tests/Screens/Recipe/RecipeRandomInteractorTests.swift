//
//  RecipeRandomInteractorTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import XCTest

@testable import recipes_uikit

class RecipeRandomInteractorTests: XCTestCase {
    var interactor: RecipeRandomInteractor!
    var mockPresenter: MockRecipePresenter!
    var mockStorageService: MockStorageService!
    var mockNetworkService: MockNetworkService!
    var recipe: RecipeDataModel!
    
    override func setUp() {
        super.setUp()
        
        mockPresenter = MockRecipePresenter()
        mockStorageService = MockStorageService()
        mockNetworkService = MockNetworkService()
        
        recipe = RecipeDataModel.mock
        
        interactor = RecipeRandomInteractor(presenter: mockPresenter,
                                            networkService: mockNetworkService,
                                            storageService: mockStorageService)
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockStorageService = nil
        mockNetworkService = nil
        recipe = nil
        super.tearDown()
    }
    
    func testFetchRecipeFromStorageSuccess() {
        mockStorageService.recipes = [recipe]
        
        interactor.fetchRecipe()
        
        XCTAssertTrue(mockPresenter.isPresentRecipeCalled)
        XCTAssertNotNil(mockPresenter.recipePresented)
        XCTAssertEqual(mockPresenter.recipePresented?.id, recipe.id)
        XCTAssertEqual(mockPresenter.recipePresented?.mealName, recipe.mealName)
        XCTAssertNil(mockPresenter.errorPresented)
    }
    
    func testFetchRecipeFromNetworkSuccess() {
        let expectation = XCTestExpectation(description: "Fetch random recipe from network successfully")
        
        mockNetworkService.randomRecipe = RecipeNetworkModel(
            id: "2",
            mealName: "Random Test Meal",
            category: "Test Category",
            area: "Test Area",
            instructions: "Random instructions",
            mealThumbURL: "https://example.com/random_image.jpg",
            youtubeURL: nil,
            sourceURL: nil,
            ingredients: []
        )
        
        interactor.fetchRecipe()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockPresenter.isPresentRecipeCalled)
            XCTAssertNotNil(self.mockPresenter.recipePresented)
            XCTAssertEqual(self.mockPresenter.recipePresented?.id, "2")
            XCTAssertEqual(self.mockPresenter.recipePresented?.mealName, "Random Test Meal")
            XCTAssertNil(self.mockPresenter.errorPresented)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchRecipeFromNetworkFailure() {
        mockStorageService.recipes = []
        let expectation = XCTestExpectation(
            description: "Handle network failure when fetching random recipe")
        mockNetworkService.error = URLError(.badServerResponse)
        
        interactor.fetchRecipe()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            XCTAssertTrue(self.mockPresenter.isPresentErrorCalled)
            XCTAssertNil(self.mockPresenter.recipePresented)
            XCTAssertNotNil(self.mockPresenter.errorPresented)
            XCTAssertEqual(self.mockPresenter.errorPresented as? URLError, URLError(.badServerResponse))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
