//
//  SettingsNavStack.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct SettingsNavStack: View {
    @State private var showSuccessAlert = false
    @State private var cachedImageCount: Int = 0

    let imageCacheManager: ImageCacheManager

    var body: some View {
        NavigationStack {
            Form {
                Section("Image Cache") {
                    Text("Cached Images: \(cachedImageCount)")

                    Button("Clear Cache", role: .destructive) {
                        imageCacheManager.clearCache()
                        cachedImageCount = imageCacheManager.cachedImageCount()
                        showSuccessAlert = true
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Section("Nikolai Nobadi") {
                    OptionalLink("GitHub Profile", url: .init(string: "https://github.com/nikolainobadi"))
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                cachedImageCount = imageCacheManager.cachedImageCount()
            }
            .alert("Image cache cleared.", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}


// MARK: - Preview
#Preview {
    SettingsNavStack(imageCacheManager: .init(delegate: ImageCacheDelegateAdapter()))
}
