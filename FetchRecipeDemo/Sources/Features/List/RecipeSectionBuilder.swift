//
//  RecipeSectionBuilder.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

enum RecipeSectionBuilder {
    static func makeSections(from list: [Recipe], matching text: String) -> [RecipeSection] {
        let filtered = filterRecipes(list, by: text)
        let dict = Dictionary(grouping: filtered, by: { String($0.name.prefix(1)).uppercased() })
        
        return dict
            .sorted { $0.key < $1.key }
            .map { key, value in
                RecipeSection(id: key, title: key, recipes: value)
            }
    }
}


// MARK: - Private Methods
private extension RecipeSectionBuilder {
    static func filterRecipes(_ recipes: [Recipe], by text: String) -> [Recipe] {
        if text.isEmpty {
            return recipes
        }
        
        return recipes.filter {
            $0.name.localizedCaseInsensitiveContains(text) || $0.cuisine.localizedCaseInsensitiveContains(text)
        }
    }
}

