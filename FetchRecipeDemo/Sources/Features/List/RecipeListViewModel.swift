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
        
        // this thread management wouldn't work if RecipeListViewModel was @MainActor
        // apparently Swift Concurrency doesn't play nice with Combine :(
        $recipes
            .combineLatest($searchText)
            .receive(on: DispatchQueue.global(qos: .background)) // performing 'intense work' on background thread
            .map { list, text in
                RecipeSectionBuilder.makeSections(from: list, matching: text)
            }
            .receive(on: DispatchQueue.main) // publishing results on MainThread
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
protocol RecipeLoader {
    func loadRecipes(from url: URL) async throws -> [Recipe]
}
