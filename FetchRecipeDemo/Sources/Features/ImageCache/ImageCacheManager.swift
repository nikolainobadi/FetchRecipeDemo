//
//  ImageCacheManager.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import CryptoKit
import Foundation

final class ImageCacheManager: Sendable {
    private let cacheDirectory: URL
    private let delegate: ImageCacheDelegate
    
    init(delegate: ImageCacheDelegate, cacheDirectoryName: String = "FetchTakeHomeTestImageCache") {
        self.delegate = delegate
        self.cacheDirectory = delegate.loadCacheDirectory(named: cacheDirectoryName)
    }
}

// MARK: - LoadImageData
extension ImageCacheManager {
    func cachedImageCount() -> Int {
        delegate.cachedImageCount(in: cacheDirectory)
    }
    
    func clearCache() {
        delegate.clearCachedImages(in: cacheDirectory)
    }
    
    func loadImageData(from url: URL) async -> Data? {
        let hashedFilename = url.absoluteString.sha256() + "." + url.pathExtension
        let path = cacheDirectory.appendingPathComponent(hashedFilename)

        if let data = delegate.loadCachedData(at: path) {
            return data
        }
        
        do {
            // you can see that images are not downloaded multiple times if already cached
            print("downloading image from url", url.path(percentEncoded: true))
            let data = try await delegate.fetchImageData(url: url)
            delegate.cacheImageData(data, at: path)
            return data
        } catch {
            return nil
        }
    }
}


// MARK: - Dependencies
protocol ImageCacheDelegate: Sendable {
    func loadCachedData(at path: URL) -> Data?
    func cacheImageData(_ data: Data, at path: URL)
    func fetchImageData(url: URL) async throws -> Data
    func loadCacheDirectory(named name: String) -> URL
    func clearCachedImages(in directory: URL)
    func cachedImageCount(in directory: URL) -> Int
}


// MARK: - Extension Dependencies
extension String {
    func sha256() -> String {
        let data = Data(self.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
