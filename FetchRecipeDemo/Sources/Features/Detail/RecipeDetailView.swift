//
//  RecipeDetailView.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    private var imageSize: CGSize {
        return .init(width: UIScreen.main.bounds.width - 50, height: 250)
    }

    var body: some View {
        VStack {
            VStack {
                Text(recipe.name)
                    .font(.title2)
                    .bold()
                
                Text("Cuisine: \(recipe.cuisine)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            AsyncImage(url: recipe.largeImageURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .clipShape(.rect(cornerRadius: 12))
            
            Spacer()
            
            OptionalLink("View Source", url: recipe.sourceURL)
            OptionalLink("Watch on YouTube", url: recipe.youtubeURL)
        }
        .padding()
    }
}


// MARK: - OptionalLink
private struct OptionalLink: View {
    let title: String
    let url: URL?
    
    init(_ title: String, url: URL?) {
        self.title = title
        self.url = url
    }
    
    var body: some View {
        if let url {
            Link(title, destination: url)
        }
    }
}


// MARK: - Preview
#Preview {
    RecipeDetailView(recipe: .sample)
}
