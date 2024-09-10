//
//  FavoritesViewControllerTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 10.09.2024.
//

import XCTest
import UIKit

@testable import recipes_uikit

class FavoritesViewControllerTests: XCTestCase {
    
    var viewController: FavoritesViewController!
    var mockInteractor: MockFavoritesInteractor!
    var recipeViewModel: FavoriteRecipeViewModel!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockFavoritesInteractor()
        viewController = FavoritesViewController()
        viewController.interactor = mockInteractor
        recipeViewModel = FavoriteRecipeViewModel(id: "1",
                                                  mealName: "Mock Meal",
                                                  category: "Mock Category",
                                                  area: "Mock Area",
                                                  imageUrl: URL(string: "https://example.com/image.jpg")!)
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockInteractor = nil
        recipeViewModel = nil
        super.tearDown()
    }
    
    func testViewWillAppearCallsFetchFavoriteRecipes() {
        viewController.viewWillAppear(false)
        
        XCTAssertTrue(mockInteractor.fetchFavoriteRecipesCalled)
    }
    
    func testDidSelectItemCallsSelectRecipe() {
        viewController.displayFavoriteRecipes([recipeViewModel])
        
        viewController.collectionView(viewController.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockInteractor.selectRecipeCalled)
        XCTAssertEqual(mockInteractor.selectedRecipeId, recipeViewModel.id)
    }
    
    func testDeleteFavoriteRecipeCallsRemoveRecipeFromFavorites() {
        viewController.displayFavoriteRecipes([recipeViewModel])
        
        viewController.deleteFavoriteRecipe(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockInteractor.removeRecipeFromFavoritesCalled)
        XCTAssertEqual(mockInteractor.removedRecipeId, recipeViewModel.id)
    }
}
