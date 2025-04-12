//
//  RecipeListViewModel.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import Foundation

final class RecipeListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var sections: [RecipeSection] = []
    @Published private var recipes: [Recipe] = []
    
    private let url: URL
    private let loader: RecipeLoader
    
    init(url: URL, loader: RecipeLoader, recipes: [Recipe] = [], searchText: String = "") {
        self.url = url
        self.loader = loader
        self.recipes = recipes
        self.searchText = searchText
        
        $recipes
            .combineLatest($searchText)
            .map { list, text in
                var filtered: [Recipe]
                if text.isEmpty {
                    filtered = list
                } else {
                    filtered = list.filter {
                        $0.name.localizedCaseInsensitiveContains(text) || $0.cuisine.localizedCaseInsensitiveContains(text)
                    }
                }
                let dict = Dictionary(grouping: filtered, by: { String($0.name.prefix(1)).uppercased() })
                
                return dict
                    .sorted { $0.key < $1.key }
                    .map { key, value in
                        RecipeSection(id: key, title: key, recipes: value)
                    }
            }
            .assign(to: &$sections)
    }
}


// MARK: - DisplayData
extension RecipeListViewModel {
    var noRecipes: Bool {
        return recipes.isEmpty
    }
}


// MARK: - Actions
@MainActor
extension RecipeListViewModel {
    func loadRecipes() async {
        do {
            recipes = try await loader.loadRecipes(from: url)
        } catch {
            recipes = []
        }
    }
}


// MARK: - Dependencies
protocol RecipeLoader: Sendable {
    func loadRecipes(from url: URL) async throws -> [Recipe]
}
