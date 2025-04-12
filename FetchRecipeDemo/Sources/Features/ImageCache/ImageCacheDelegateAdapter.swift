//
//  ImageCacheDelegateAdapter.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import Foundation

final class ImageCacheDelegateAdapter: ImageCacheDelegate {
    func loadCachedData(at path: URL) -> Data? {
        return try? Data(contentsOf: path)
    }
    
    func cacheImageData(_ data: Data, at path: URL) {
        try? data.write(to: path, options: [.atomic])
    }
    
    func fetchImageData(url: URL) async throws -> Data {
        return try await URLSession.shared.data(from: url).0
    }
    
    func loadCacheDirectory(named name: String) -> URL {
        let fileManager = FileManager.default
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let url = caches.appendingPathComponent(name, isDirectory: true)
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
