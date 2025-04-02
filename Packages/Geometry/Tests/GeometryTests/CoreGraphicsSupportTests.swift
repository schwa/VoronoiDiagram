import Testing
@testable import Geometry
import CoreGraphics
import Numerics

// MARK: - CGPoint Extension Tests

@Test func testCGPointIsApproximatelyEqual() async throws {
    // Exact equality
    let p1 = CGPoint(x: 1.0, y: 2.0)
    let p2 = CGPoint(x: 1.0, y: 2.0)
    #expect(p1.isApproximatelyEqual(to: p2, absoluteTolerance: 0.0))
    #expect(p1.isApproximatelyEqual(to: p2, absoluteTolerance: 0.01))
    
    // Within tolerance
    let p3 = CGPoint(x: 1.000001, y: 2.000001)
    #expect(p1.isApproximatelyEqual(to: p3, absoluteTolerance: 0.001))
    
    // At the edge of tolerance
    let p4 = CGPoint(x: 1.01, y: 2.01)
    #expect(p1.isApproximatelyEqual(to: p4, absoluteTolerance: 0.02))
    #expect(!p1.isApproximatelyEqual(to: p4, absoluteTolerance: 0.005))
    
    // Not equal
    let p5 = CGPoint(x: 2.0, y: 3.0)
    #expect(!p1.isApproximatelyEqual(to: p5, absoluteTolerance: 0.01))
}

@Test func testCGPointLength() async throws {
    let p1 = CGPoint(x: 3.0, y: 4.0)
    #expect(p1.length == 5.0)
    
    let p2 = CGPoint(x: -3.0, y: -4.0)
    #expect(p2.length == 5.0)
}

@Test func testCGPointOperators() async throws {
    let p1 = CGPoint(x: 1.0, y: 2.0)
    let p2 = CGPoint(x: 3.0, y: 4.0)
    
    // Addition
    let sum = p1 + p2
    #expect(sum.x == 4.0)
    #expect(sum.y == 6.0)
    
    // Subtraction
    let diff = p2 - p1
    #expect(diff.x == 2.0)
    #expect(diff.y == 2.0)
    
    // Scalar multiplication
    let mult = p1 * 2.0
    #expect(mult.x == 2.0)
    #expect(mult.y == 4.0)
    
    // Division
    let div = p2 / 2.0
    #expect(div.x == 1.5)
    #expect(div.y == 2.0)
}

@Test func testCGPointDotProduct() async throws {
    let p1 = CGPoint(x: 1.0, y: 2.0)
    let p2 = CGPoint(x: 3.0, y: 4.0)
    
    let dot = p1.dot(p2)
    #expect(dot == 11.0) // 1*3 + 2*4 = 11
}

@Test func testCGPointDistance() async throws {
    let p1 = CGPoint(x: 0.0, y: 0.0)
    let p2 = CGPoint(x: 3.0, y: 4.0)
    
    let dist = p1.distance(to: p2)
    #expect(dist == 5.0)
}

// MARK: - CGRect Extension Tests

@Test func testCGRectFromPoints() async throws {
    let points = [
        CGPoint(x: 1.0, y: 1.0),
        CGPoint(x: 5.0, y: 1.0),
        CGPoint(x: 5.0, y: 5.0),
        CGPoint(x: 1.0, y: 5.0)
    ]
    
    let rect = CGRect(points)
    #expect(rect.minX == 1.0)
    #expect(rect.minY == 1.0)
    #expect(rect.maxX == 5.0)
    #expect(rect.maxY == 5.0)
}

@Test func testCGRectPointAccessors() async throws {
    let rect = CGRect(x: 1.0, y: 2.0, width: 3.0, height: 4.0)
    
    #expect(rect.minXMinY.x == 1.0)
    #expect(rect.minXMinY.y == 2.0)
    
    #expect(rect.maxXMinY.x == 4.0)
    #expect(rect.maxXMinY.y == 2.0)
    
    #expect(rect.maxXMaxY.x == 4.0)
    #expect(rect.maxXMaxY.y == 6.0)
    
    #expect(rect.minXMaxY.x == 1.0)
    #expect(rect.minXMaxY.y == 6.0)
    
    #expect(rect.midXMidY.x == 2.5)
    #expect(rect.midXMidY.y == 4.0)
    
    #expect(rect.midXMinY.x == 2.5)
    #expect(rect.midXMinY.y == 2.0)
    
    #expect(rect.midXMaxY.x == 2.5)
    #expect(rect.midXMaxY.y == 6.0)
    
    #expect(rect.minXMidY.x == 1.0)
    #expect(rect.minXMidY.y == 4.0)
    
    #expect(rect.maxXMidY.x == 4.0)
    #expect(rect.maxXMidY.y == 4.0)
}

// MARK: - Geometry Function Tests

@Test func testCrossProduct() async throws {
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 1, y: 0)
    let c1 = CGPoint(x: 0, y: 1)
    
    let crossProduct = cross(a, b, c1)
    #expect(crossProduct == 1.0)
    
    // Cross product is twice the signed area
    #expect(crossProduct == 2 * signedArea(a: a, b: b, c: c1))
}

@Test func testDistance() async throws {
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 3, y: 4)
    
    #expect(distance(a, b) == 5.0)
    #expect(distanceSquared(a, b) == 25.0)
}

@Test func testSignedArea() async throws {
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 1, y: 0)
    let c = CGPoint(x: 0, y: 1)
    
    #expect(signedArea(a: a, b: b, c: c) == 0.5)
    #expect(signedArea(a: a, b: c, c: b) == -0.5)
}

@Test func testNormalizeVector() async throws {
    let v1 = CGVector(dx: 3.0, dy: 4.0)
    let normalized = v1.normalized

    #expect(normalized.dx.isApproximatelyEqual(to: 0.6, absoluteTolerance: 1e-6))
    #expect(normalized.dy.isApproximatelyEqual(to: 0.8, absoluteTolerance: 1e-6))

    // Zero vector case
    let v2 = CGVector(dx: 0.0, dy: 0.0)
    let normalizedZero = v2.normalized

    #expect(normalizedZero.dx == 0.0)
    #expect(normalizedZero.dy == 0.0)
} 
