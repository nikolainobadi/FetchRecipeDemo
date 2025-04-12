//
//  RecipeSectionBuilderTests.swift
//  FetchRecipeDemoTests
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import Testing
import Foundation
@testable import FetchRecipeDemo

struct RecipeSectionBuilderTests {
    @Test("Returns one section with all recipes when search text is empty")
    func returnsOneSectionWithAllRecipesWhenSearchTextIsEmpty() {
        let recipes = makeRecipes([
            ("Apple Pie", "American"),
            ("Almond Cake", "British")
        ])

        let sections = RecipeSectionBuilder.makeSections(from: recipes, matching: "")

        #expect(sections.count == 1)
        #expect(sections.first?.id == "A")
        #expect(sections.first?.recipes.count == 2)
    }

    @Test("Filters recipes by name")
    func filtersRecipesByNameOrCuisine() {
        let recipes = makeRecipes([
            ("Apple Pie", "American"),
            ("Beef Stew", "French"),
            ("Curry", "Indian")
        ])

        let sections = RecipeSectionBuilder.makeSections(from: recipes, matching: "Beef")

        #expect(sections.count == 1)
        #expect(sections.first?.id == "B")
        #expect(sections.first?.recipes.first?.name == "Beef Stew")
    }

    @Test("Groups recipes alphabetically by name prefix")
    func groupsRecipesAlphabeticallyByNamePrefix() {
        let recipes = makeRecipes([
            ("Apple", "A"),
            ("Banana", "B"),
            ("Carrot", "C")
        ])

        let sections = RecipeSectionBuilder.makeSections(from: recipes, matching: "")

        #expect(sections.count == 3)
        #expect(sections[0].id == "A")
        #expect(sections[1].id == "B")
        #expect(sections[2].id == "C")
    }

    @Test("Returns empty section list if no matches found")
    func returnsEmptySectionListIfNoMatchesFound() {
        let recipes = makeRecipes([
            ("Apple", "A"),
            ("Banana", "B")
        ])

        let sections = RecipeSectionBuilder.makeSections(from: recipes, matching: "xyz")

        #expect(sections.isEmpty)
    }
}


// MARK: - Helpers
private extension RecipeSectionBuilderTests {
    func makeRecipes(_ entries: [(String, String)]) -> [Recipe] {
        return entries.map { name, cuisine in
            Recipe(
                id: UUID(),
                name: name,
                cuisine: cuisine,
                largeImageURL: .init(string: "https://example.com/large.jpg")!,
                smallImageURL: .init(string: "https://example.com/small.jpg")!,
                sourceURL: nil,
                youtubeURL: nil
            )
        }
    }
}
