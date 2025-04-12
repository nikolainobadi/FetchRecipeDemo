//
//  Recipe+RemoteInit.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

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
