//
//  ContentView.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var recipes: [Recipe] = []
    
    let url: URL
    
    private func loadRecipes() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
            
            recipes = decoded.recipes.map({ .init(remote: $0) })
        } catch {
            print("no recipes")
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(recipes) { recipe in
                    RecipeRow(recipe: recipe)
                }
            }
            .navigationTitle("Recipes")
            .task {
                await loadRecipes()
            }
            .refreshable {
                await loadRecipes()
            }
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
#Preview {
    ContentView(url: .production)
}

struct RecipeResponse: Codable {
    let recipes: [RemoteRecipe]
}

struct RemoteRecipe: Codable {
    let cuisine: String
    let name: String
    let photoURLLarge: URL
    let photoURLSmall: URL
    let uuid: UUID
    let sourceURL: URL?
    let youtubeURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case uuid
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

extension URL {
    static var production: URL {
        return .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    }
    
    static var malformed: URL {
        return .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
    }
    
    static var empty: URL {
        return .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
    }
}

struct Recipe: Identifiable, Hashable {
    let id: UUID
    let name: String
    let cuisine: String
    let largeImageURL: URL
    let smallImageURL: URL
    let sourceURL: URL?
    let youtubeURL: URL?
}

extension Recipe {
    init(remote: RemoteRecipe) {
        self.init(
            id: remote.uuid,
            name: remote.name,
            cuisine: remote.cuisine,
            largeImageURL: remote.photoURLLarge,
            smallImageURL: remote.photoURLSmall,
            sourceURL: remote.sourceURL,
            youtubeURL: remote.youtubeURL
        )
    }
}
