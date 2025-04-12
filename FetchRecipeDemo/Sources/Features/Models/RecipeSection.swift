//
//  RecipeSection.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

struct RecipeSection: Identifiable {
    let id: String
    let title: String
    let recipes: [Recipe]
}
