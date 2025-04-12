//
//  MainTabView.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct MainTabView: View {
    let imageCacheManager: ImageCacheManager

    var body: some View {
        TabView {
            RecipeNavStack(recipeURL: .production, imageCacheManager: imageCacheManager)
                .tabItem {
                    Label("Recipes", systemImage: "fork.knife")
                }

            SettingsNavStack(imageCacheManager: imageCacheManager)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}
