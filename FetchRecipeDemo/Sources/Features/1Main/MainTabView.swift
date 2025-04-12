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
            Tab("Recipes", systemImage: "fork.knife") {
                RecipeNavStack(recipeURL: .production, imageCacheManager: imageCacheManager)
            }
            
            Tab("Settings", systemImage: "gearshape") {
                SettingsNavStack(imageCacheManager: imageCacheManager)
            }
        }
    }
}
