//
//  RecipeListView.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel: RecipeListViewModel
    
    let loadImageData: (URL) async -> Data?
    
    var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section(section.title) {
                    ForEach(section.recipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeRow(recipe: recipe, loadImageData: loadImageData)
                        }
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .handlingEmptyList(when: viewModel.noRecipes, title: viewModel.emptyListTitle, description: viewModel.emptyListDescription)
        .task {
            await viewModel.loadRecipes()
        }
        .refreshable {
            await viewModel.loadRecipes()
        }
    }
}


// MARK: - Row
private struct RecipeRow: View {
    let recipe: Recipe
    let loadImageData: (URL) async -> Data?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ManualImageView(url: recipe.smallImageURL, size: .init(width: 60, height: 60), loadImageData: loadImageData)

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}


// MARK: - Preview
#Preview {
    NavigationStack {
        RecipeListView(viewModel: .init(url: .production, loader: PreviewLoader()), loadImageData: { _ in nil })
            .navigationTitle("Recipes")
    }
}

private final class PreviewLoader: RecipeLoader {
    func loadRecipes(from url: URL) async throws -> [Recipe] {
        Recipe.sampleList
    }
}
