//
//  RecipeListViewModelTests.swift
//  FetchRecipeDemoTests
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import Testing
import Foundation
@testable import FetchRecipeDemo

@MainActor
final class RecipeListViewModelTests: TrackingMemoryLeaks {
    @Test("Starting values empty")
    func emptyStartingValues() {
        let (sut, _) = makeSUT(url: .stub)
        #expect(sut.searchText.isEmpty)
        #expect(sut.sections.isEmpty)
        #expect(sut.noRecipes)
    }

    @Test("Setting recipes updates sections")
    func settingRecipesUpdatesSections() async throws {
        let recipes = [
            makeRecipe(name: "Apple Pie", cuisine: "American"),
            makeRecipe(name: "Baklava", cuisine: "Turkish"),
            makeRecipe(name: "Brownies", cuisine: "American"),
        ]

        let (sut, _) = makeSUT(url: .stub, recipes: recipes)

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(sut.sections.count == 2)
        #expect(sut.sections.map(\.title).sorted() == ["A", "B"])
        #expect(sut.sections.flatMap(\.recipes).count == recipes.count)
    }
    
    @Test("Successfully loads recipes and updates sections")
    func successfullyLoadsRecipesAndUpdatesSections() async throws {
        let recipes = [
            makeRecipe(name: "Ziti", cuisine: "Italian"),
            makeRecipe(name: "Empanadas", cuisine: "Argentinian")
        ]

        let (sut, loader) = makeSUT(url: .stub, recipes: recipes)

        sut.searchText = ""
        sut.sections = []
        
        await sut.loadRecipes()

        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(loader.loadURL == .stub)
        #expect(!sut.noRecipes)
        #expect(sut.sections.count == 2)
        #expect(sut.sections.map(\.title).sorted() == ["E", "Z"])
    }

    @Test("Clears recipes on load failure")
    func clearsRecipesOnLoadFailure() async throws {
        let (sut, _) = makeSUT(url: .stub, throwError: true)

        await sut.loadRecipes()

        #expect(sut.noRecipes)
        #expect(sut.sections.isEmpty)
    }

    @Test("Returns correct title and description when data is valid")
    func returnsCorrectTitleAndDescriptionWhenDataIsValid() {
        let (sut, _) = makeSUT(url: .stub)

        sut.searchText = "Anything"
        sut.sections = []

        #expect(!sut.invalidData)
        #expect(sut.emptyListTitle == "No Recipes")
        #expect(sut.emptyListDescription == "Check your connection or try again later")
    }

    @Test("Returns correct title and description when data is invalid")
    func returnsCorrectTitleAndDescriptionWhenDataIsInvalid() async throws {
        let (sut, _) = makeSUT(url: .stub, throwError: true)

        await sut.loadRecipes()

        #expect(sut.invalidData)
        #expect(sut.emptyListTitle == "Invalid Data")
        #expect(sut.emptyListDescription == "Looks like the recipe list is corrupted")
    }
}


// MARK: - SUT
private extension RecipeListViewModelTests {
    func makeSUT(url: URL, recipes: [Recipe] = [], throwError: Bool = false, fileID: String = #fileID, filePath: String = #filePath, line: Int = #line, column: Int = #column) -> (sut: RecipeListViewModel, delegate: MockLoader) {
        let loader = MockLoader(recipes: recipes, throwError: throwError)
        let sut = RecipeListViewModel(url: url, loader: loader, recipes: recipes)
        trackForMemoryLeaks(sut, fileID: fileID, filePath: filePath, line: line, column: column)
        return (sut, loader)
    }

    func makeRecipe(name: String = "First", cuisine: String = "Tasty") -> Recipe {
        return .init(
            id: .init(),
            name: name,
            cuisine: cuisine,
            largeImageURL: URL(string: "https://example.com/large.jpg")!,
            smallImageURL: URL(string: "https://example.com/small.jpg")!,
            sourceURL: nil,
            youtubeURL: nil
        )
    }
}


// MARK: - Mocks
private extension RecipeListViewModelTests {
    final class MockLoader: RecipeLoader, @unchecked Sendable {
        private let throwError: Bool
        private let recipes: [Recipe]

        private(set) var loadURL: URL?

        init(recipes: [Recipe], throwError: Bool) {
            self.recipes = recipes
            self.throwError = throwError
        }

        func loadRecipes(from url: URL) async throws -> [Recipe] {
            loadURL = url
            if throwError { throw NSError(domain: "Test", code: 0) }
            return recipes
        }
    }
}


// MARK: - Helpers
private extension URL {
    static var stub: URL { URL(string: "https://example.com/recipes.json")! }
}

