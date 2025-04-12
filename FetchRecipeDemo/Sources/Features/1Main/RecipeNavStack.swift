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
            RecipeListView(url: url)
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
