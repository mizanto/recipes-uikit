//
//  RecipeViewControllerTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import XCTest

@testable import recipes_uikit

class RecipeViewControllerTests: XCTestCase {
    
    var viewController: RecipeViewController!
    var mockInteractor: MockRecipeRandomInteractor!
    
    override func setUp() {
        super.setUp()
        
        mockInteractor = MockRecipeRandomInteractor()
        viewController = RecipeViewController(screenType: .random)
        viewController.interactor = mockInteractor
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    func testGetRandomRecipeButtonTapped() {
        viewController.getRandomRecipe()
        
        XCTAssertTrue(mockInteractor.fetchRandomRecipeCalled)
    }
    
    func testToggleFavoriteStatusButtonTapped() {
        viewController.toggleFavoriteStatus()
        
        XCTAssertTrue(mockInteractor.toggleFavoriteStatusCalled)
    }
    
    func testFetchRecipeCalledOnViewWillAppear() {
        viewController.viewWillAppear(true)
        
        XCTAssertTrue(mockInteractor.fetchRecipeCalled)
    }
}
