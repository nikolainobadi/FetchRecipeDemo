//
//  FetchRecipeDemoApp.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

@main
struct FetchRecipeDemoApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView(imageCacheManager: .init(delegate: ImageCacheDelegateAdapter()))
        }
    }
}


// MARK: - Extension Dependencies
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
