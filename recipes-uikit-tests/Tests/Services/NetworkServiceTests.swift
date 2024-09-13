//
//  NetworkServiceTests.swift
//  recipes-uikit-tests
//
//  Created by Sergey Bendak on 9.09.2024.
//

import XCTest

@testable import recipes_uikit

final class NetworkServiceTests: XCTestCase {
    var sut: NetworkService!
    var urlSessionMock: URLSessionMock!

    override func setUp() {
        super.setUp()
        urlSessionMock = URLSessionMock()
        sut = NetworkService(session: urlSessionMock)
    }

    override func tearDown() {
        sut = nil
        urlSessionMock = nil
        super.tearDown()
    }

    func testFetchRandomRecipeSuccess() async throws {
        let jsonString = """
        {
            "meals": [
                {
                    "idMeal": "1",
                    "strMeal": "Mock Recipe",
                    "strCategory": "Dessert",
                    "strArea": "American",
                    "strInstructions": "Mix ingredients",
                    "strMealThumb": "https://example.com/image.jpg",
                    "strTags": "tag1,tag2",
                    "strYoutube": "https://youtube.com",
                    "strSource": "https://source.com",
                    "strIngredient1": "Sugar",
                    "strMeasure1": "2 tbsp"
                }
            ]
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        urlSessionMock.data = jsonData
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        
        let recipe = try await sut.fetchRandomRecipe()

        XCTAssertEqual(recipe.id, "1")
        XCTAssertEqual(recipe.mealName, "Mock Recipe")
        XCTAssertEqual(recipe.category, "Dessert")
        XCTAssertEqual(recipe.area, "American")
        XCTAssertEqual(recipe.instructions, "Mix ingredients")
        XCTAssertEqual(recipe.mealThumbURL, URL(string: "https://example.com/image.jpg"))
        XCTAssertEqual(recipe.tags, "tag1,tag2")
        XCTAssertEqual(recipe.youtubeURL, URL(string: "https://youtube.com"))
        XCTAssertEqual(recipe.sourceURL, URL(string: "https://source.com"))
        XCTAssertEqual(recipe.ingredients.count, 1)
        XCTAssertEqual(recipe.ingredients.first?.name, "Sugar")
        XCTAssertEqual(recipe.ingredients.first?.measure, "2 tbsp")
    }

    func testFetchRandomRecipeFailure() async throws {
        urlSessionMock.error = URLError(.badServerResponse)

        do {
            _ = try await sut.fetchRandomRecipe()
            XCTFail("Expected error to be thrown, but got success.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .badServerResponse)
            XCTAssertEqual(error.localizedDescription, "The server response was invalid.")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testFetchRandomRecipeDecodingError() async throws {
        let invalidJsonData = "Invalid JSON".data(using: .utf8)
        urlSessionMock.data = invalidJsonData
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)

        do {
            _ = try await sut.fetchRandomRecipe()
            XCTFail("Expected decoding error to be thrown, but got success.")
        } catch let NetworkError.decodingError(decodingError as DecodingError) {
            guard case .dataCorrupted(let context) = decodingError else {
                return XCTFail("Expected DecodingError.dataCorrupted but got \(decodingError)")
            }
            XCTAssertEqual(context.debugDescription, "The given data was not valid JSON.")
            XCTAssertEqual(context.codingPath.count, 0)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testFetchRandomRecipeInvalidURL() async throws {
        let invalidAPIConfig = APIConfiguration(baseURL: "htp://invalid-url")
        sut = NetworkService(session: urlSessionMock, apiConfig: invalidAPIConfig)

        do {
            let _ = try await sut.fetchRandomRecipe()
            XCTFail("Expected badURL error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .badURL)
            XCTAssertEqual(error.localizedDescription, "The URL provided was invalid.")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
