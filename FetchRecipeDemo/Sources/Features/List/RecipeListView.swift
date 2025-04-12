//
//  RecipeListView.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel: RecipeListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section(section.title) {
                    ForEach(section.recipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeRow(recipe: recipe)
                        }
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
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
    
    var body: some View {
        HStack {
            AsyncImage(url: recipe.smallImageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 60)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(.rect(cornerRadius: 8))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            
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
//#Preview {
//    RecipeListView()
//}
