//
//  Recipe.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import Foundation

struct Recipe: Identifiable, Hashable {
    let id: UUID
    let name: String
    let cuisine: String
    let largeImageURL: URL
    let smallImageURL: URL
    let sourceURL: URL?
    let youtubeURL: URL?
}
