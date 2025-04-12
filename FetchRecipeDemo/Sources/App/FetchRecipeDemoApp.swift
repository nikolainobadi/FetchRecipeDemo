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
            ContentView(url: .production)
        }
    }
}
