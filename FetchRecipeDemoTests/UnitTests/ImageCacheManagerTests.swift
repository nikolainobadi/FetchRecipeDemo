//
//  ImageCacheManagerTests.swift
//  FetchRecipeDemoTests
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import Testing
import Foundation
@testable import FetchRecipeDemo

struct ImageCacheManagerTests {
    @Test("Returns cached data when it exists")
    func returnsCachedDataWhenExists() async throws {
        let expectedData = "123".data(using: .utf8)!
        let delegate = MockDelegate(cachedData: expectedData)
        let manager = ImageCacheManager(delegate: delegate)
        let url = URL(string: "https://example.com/image.png")!
        let result = await manager.loadImageData(from: url)

        #expect(result == expectedData)
        #expect(delegate.fetchedURLs.isEmpty)
        #expect(delegate.cachedItems.isEmpty)
    }

    @Test("Downloads and caches when data not found")
    func downloadsAndCachesWhenDataNotFound() async throws {
        let expectedData = "xyz".data(using: .utf8)!
        let delegate = MockDelegate(fetchedData: expectedData)
        let manager = ImageCacheManager(delegate: delegate)
        let url = URL(string: "https://example.com/test.jpg")!
        let result = await manager.loadImageData(from: url)

        #expect(result == expectedData)
        #expect(delegate.fetchedURLs.contains(url))
        #expect(delegate.cachedItems.count == 1)
    }

    @Test("Handles fetch failure gracefully")
    func handlesFetchFailureGracefully() async throws {
        let delegate = MockDelegate(throwError: true)
        let manager = ImageCacheManager(delegate: delegate)
        let url = URL(string: "https://example.com/fail.jpg")!
        let result = await manager.loadImageData(from: url)

        #expect(result == nil)
    }

    @Test("Returns correct cached image count")
    func returnsCorrectCachedImageCount() {
        let delegate = MockDelegate(imageCount: 7)
        let manager = ImageCacheManager(delegate: delegate)

        #expect(manager.cachedImageCount() == 7)
    }

    @Test("Clears cached images")
    func clearsCachedImages() {
        let delegate = MockDelegate()
        let manager = ImageCacheManager(delegate: delegate)

        #expect(!delegate.didClearCache)
        manager.clearCache()
        #expect(delegate.didClearCache)
    }
}


// MARK: - Mocks
private extension ImageCacheManagerTests {
    final class MockDelegate: ImageCacheDelegate, @unchecked Sendable {
        private let cachedData: Data?
        private let fetchedData: Data?
        private let throwError: Bool
        private let imageCount: Int
        private let mockCacheDirectory: URL = URL(fileURLWithPath: "/mock/cache")

        private(set) var didClearCache = false
        private(set) var fetchedURLs: [URL] = []
        private(set) var cachedItems: [(data: Data, path: URL)] = []

        init(cachedData: Data? = nil, fetchedData: Data? = nil, throwError: Bool = false, imageCount: Int = 0) {
            self.cachedData = cachedData
            self.fetchedData = fetchedData
            self.throwError = throwError
            self.imageCount = imageCount
        }

        func loadCachedData(at path: URL) -> Data? {
            return cachedData
        }

        func cacheImageData(_ data: Data, at path: URL) {
            cachedItems.append((data, path))
        }

        func fetchImageData(url: URL) async throws -> Data {
            fetchedURLs.append(url)
            if throwError { throw URLError(.badURL) }
            return fetchedData ?? Data()
        }

        func loadCacheDirectory(named name: String) -> URL {
            return mockCacheDirectory
        }

        func clearCachedImages(in directory: URL) {
            didClearCache = true
        }

        func cachedImageCount(in directory: URL) -> Int {
            return imageCount
        }
    }
}
