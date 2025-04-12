//
//  RecipeDetailView.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    let loadImageData: (URL) async -> Data?
    
    private var imageSize: CGSize {
        return .init(width: UIScreen.main.bounds.width - 50, height: 250)
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.title2)
                    .bold()
                
                Text("Cuisine: \(recipe.cuisine)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            ManualImageView(url: recipe.largeImageURL, size: imageSize, loadImageData: loadImageData)
                .padding()
                .clipShape(.rect(cornerRadius: 10))
            Spacer()
            OptionalLink("View Source", url: recipe.sourceURL)
            OptionalLink("Watch on YouTube", url: recipe.youtubeURL)
        }
        .padding()
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - OptionalLink
struct OptionalLink: View {
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
    RecipeDetailView(recipe: .sample, loadImageData: { _ in nil })
}
