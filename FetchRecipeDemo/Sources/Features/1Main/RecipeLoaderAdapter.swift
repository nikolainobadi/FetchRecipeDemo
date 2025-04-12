//
//  RecipeLoaderAdapter.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import Foundation

final class RecipeLoaderAdapter: RecipeLoader {
    func loadRecipes(from url: URL) async throws -> [Recipe] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
        
        return decoded.recipes.map({ .init(remote: $0) })
    }
}
