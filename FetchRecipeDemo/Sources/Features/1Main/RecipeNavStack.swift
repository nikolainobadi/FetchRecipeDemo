//
//  RecipeNavStack.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct RecipeNavStack: View {
    let recipeURL: URL
    let imageCacheManager: ImageCacheManager
    
    var body: some View {
        NavigationStack {
            RecipeListView(viewModel: .customInit(url: recipeURL), loadImageData: imageCacheManager.loadImageData(from:))
                .navigationTitle("Recipes")
                .navigationDestination(for: Recipe.self) { recipe in
                    RecipeDetailView(recipe: recipe, loadImageData: imageCacheManager.loadImageData(from:))
                }
        }
    }
}

// MARK: - Preview
#Preview("Production") {
    RecipeNavStack(recipeURL: .production, imageCacheManager: .init(delegate: ImageCacheDelegateAdapter()))
}

#Preview("Malformed") {
    RecipeNavStack(recipeURL: .malformed, imageCacheManager: .init(delegate: ImageCacheDelegateAdapter()))
}

#Preview("Empty") {
    RecipeNavStack(recipeURL: .empty, imageCacheManager: .init(delegate: ImageCacheDelegateAdapter()))
}


// MARK: - Extension Dependencies
private extension RecipeListViewModel {
    static func customInit(url: URL) -> RecipeListViewModel {
        return .init(url: url, loader: RecipeLoaderAdapter())
    }
}
