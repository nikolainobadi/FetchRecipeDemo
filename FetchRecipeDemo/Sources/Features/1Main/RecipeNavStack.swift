//
//  RecipeNavStack.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct RecipeNavStack: View {
    let url: URL
    
    var body: some View {
        NavigationStack {
            RecipeListView(viewModel: .init(url: url, loader: RecipeLoaderAdapter()))
                .navigationTitle("Recipes")
                .navigationDestination(for: Recipe.self) { recipe in
                    RecipeDetailView(recipe: recipe)
                }
        }
    }
}


// MARK: - Preview
#Preview {
    RecipeNavStack(url: .production)
}

final class RecipeLoaderAdapter: RecipeLoader {
    func loadRecipes(from url: URL) async throws -> [Recipe] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
        
        return decoded.recipes.map({ .init(remote: $0) })
    }
}
