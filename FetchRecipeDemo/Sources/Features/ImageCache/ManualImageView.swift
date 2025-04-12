//
//  ManualImageView.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct ManualImageView: View {
    @State private var imageData: Data?
    @State private var isLoading = false
    
    let url: URL
    let size: CGSize
    let loadImageData: (URL) async -> Data?

    var body: some View {
        ZStack {
            if let imageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 8))
            } else if isLoading {
                ProgressView()
                    .frame(width: size.width, height: size.height)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width, height: size.height)
                    .foregroundColor(.secondary)
            }
        }
        .task {
            if imageData == nil && !isLoading {
                isLoading = true
                imageData = await loadImageData(url)
                isLoading = false
            }
        }
    }
}
