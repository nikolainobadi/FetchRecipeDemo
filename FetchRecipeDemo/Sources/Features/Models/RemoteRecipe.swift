//
//  RemoteRecipe.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import Foundation

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
