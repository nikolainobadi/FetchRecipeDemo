//
//  TrackingMemoryLeaks.swift
//  FetchRecipeDemoTests
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import Testing

/// Helper class taken from my test-helper kit, `NnTestKit`, public open-source on `GitHub`: https://github.com/nikolainobadi/NnTestKit

/// A utility class to track objects for memory leaks in tests using Swift's `Testing` framework.
/// When the instance of this class is deallocated, it verifies that all tracked objects have also been deallocated.
///
/// ## Example
/// ```swift
/// import Testing
/// @testable import YourModule
///
/// final class MyClassSwiftTesting: TrackingMemoryLeaks {
///     @Test("MyClass leaks memory due to retain cycle")
///     func test_memoryLeakDetected() {
///         let _ = makeSUT()
///
///     }
/// }
///
/// private extension MyClassSwiftTesting {
///     func makeSUT(fileID: String = #fileID, filePath: String = #filePath, line: Int = #line, column: Int = #column) -> MyClass {
///         let service = MyService()
///         let sut = MyClass(service: service)
///         trackForMemoryLeaks(sut, fileID: fileID, filePath: filePath, line: line, column: column)
///         return sut
///     }
/// }
/// ```
class TrackingMemoryLeaks {
    private var trackingList: [TrackableObject] = []
    
    init() { }

    /// On deinitialization—similar to using `addTeardownBlock` in `XCTestCase`—this asserts that all tracked objects have been deallocated.
    /// If any object is still in memory at teardown, the test fails with a descriptive message and the source location where tracking was initiated.
    deinit {
        for object in trackingList {
            #expect(object.weakRef == nil, "\(object.errorMessage)", sourceLocation: object.sourceLocation)
        }
    }

    /// Tracks the given reference for memory leaks. Should be called within a test method.
    /// - Parameters:
    ///   - ref: The reference to an object that should be deallocated by the end of the test.
    ///   - fileID: The file ID where the tracking is set. Default is the current file.
    ///   - filePath: The file path where the tracking is set. Default is the current path.
    ///   - line: The line number where the tracking is set. Default is the current line.
    ///   - column: The column number where the tracking is set. Default is the current column.
    func trackForMemoryLeaks(_ ref: AnyObject, fileID: String = #fileID, filePath: String = #filePath, line: Int = #line, column: Int = #column) {
        trackingList.append(.init(weakRef: ref, sourceLocation: .init(fileID: fileID, filePath: filePath, line: line, column: column)))
    }
}


// MARK: - Dependencies
/// A lightweight wrapper used to hold a weak reference and its source location for memory leak tracking.
private final class TrackableObject {
    /// A weak reference to the tracked object. Should be nil when deallocated.
    weak var weakRef: AnyObject?

    /// A descriptive error message shown if the object is not deallocated.
    let errorMessage: String

    /// The location in the source code where the object was tracked.
    let sourceLocation: SourceLocation

    /// Initializes a new `TrackableObject` instance.
    /// - Parameters:
    ///   - weakRef: The object to track (stored weakly).
    ///   - sourceLocation: The source code location where the object is being tracked.
    init(weakRef: AnyObject, sourceLocation: SourceLocation) {
        self.weakRef = weakRef
        self.sourceLocation = sourceLocation
        self.errorMessage = "\(String(describing: weakRef)) should have been deallocated. Potential memory leak"
    }
}

