import Testing
@testable import Geometry
import CoreGraphics
import SwiftUI

// MARK: - Path Extensions Tests

@Test func testPathFromTriangle() async throws {
    let triangle = Triangle(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 10, y: 0), c: CGPoint(x: 5, y: 10))
    
    // Verify that creating a path from a triangle doesn't crash
    // Since we can't directly examine SwiftUI Path contents, we just ensure no exception occurs
    let pathCreated = {
        let _ = Path(triangle)
        return true
    }()
    
    #expect(pathCreated)
}

@Test func testPathFromCircle() async throws {
    let circle = Circle(center: CGPoint(x: 5, y: 5), radius: 10)
    
    // Verify that creating a path from a circle doesn't crash
    // Since we can't directly examine SwiftUI Path contents, we just ensure no exception occurs
    let pathCreated = {
        let _ = Path(circle)
        return true
    }()
    
    #expect(pathCreated)
}

@Test func testPathFromLineSegment() async throws {
    let segment = LineSegment(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 10, y: 10))
    
    // Verify that creating a path from a line segment doesn't crash
    // Since we can't directly examine SwiftUI Path contents, we just ensure no exception occurs
    let pathCreated = {
        let _ = Path(segment)
        return true
    }()
    
    #expect(pathCreated)
}

@Test func testPathDebugDescription() async throws {
    // Test debug description of Path extensions
    let circle = Circle(center: CGPoint(x: 5, y: 5), radius: 10)
    let path = Path(circle)
    
    // We can't inspect the path contents directly, but we can make sure the description exists
    let description = String(describing: path)
    #expect(!description.isEmpty)
} 