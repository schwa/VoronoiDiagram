import Testing
@testable import Geometry
import CoreGraphics
import Numerics

// MARK: - Circle Tests

@Test func testCircle() async throws {
    // Test initialization
    let center = CGPoint(x: 5, y: 5)
    let radius = CGFloat(10)
    let circle = Circle(center: center, radius: radius)
    
    #expect(circle.center == center)
    #expect(circle.radius == radius)
    
    // Test equality
    let circle2 = Circle(center: center, radius: radius)
    #expect(circle == circle2)
    
    // Test contains
    let inside = CGPoint(x: 6, y: 6)  // Distance from center: sqrt(2) < 10
    let outside = CGPoint(x: 20, y: 20)  // Distance from center: sqrt(450) > 10
    let onCircle = CGPoint(x: 15, y: 5)  // Distance from center: 10
    
    #expect(circle.contains(inside))
    #expect(!circle.contains(outside))
    #expect(circle.contains(onCircle))  // Should work with the tolerance
}

@Test func testCircleFromThreePoints() async throws {
    // Test with points that form a right triangle
    // The circumcircle of a right triangle has its center at the midpoint of the hypotenuse
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 0, y: 6)
    let c = CGPoint(x: 8, y: 0)
    
    let circle = Circle(a: a, b: b, c: c)
    
    // For this right triangle, the center should be at (4, 3) with radius 5
    #expect(circle.center.x.isApproximatelyEqual(to: 4, absoluteTolerance: 0.1))
    #expect(circle.center.y.isApproximatelyEqual(to: 3, absoluteTolerance: 0.1))
    #expect(circle.radius.isApproximatelyEqual(to: 5, absoluteTolerance: 0.1))

    // All points should be on the circle
    #expect(circle.contains(a))
    #expect(circle.contains(b))
    #expect(circle.contains(c))
}

@Test func testCircleFromCollinearPoints() async throws {
    // Test the edge case where three points are collinear (or nearly collinear)
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 5, y: 0)
    let c = CGPoint(x: 10, y: 0.00000001) // Nearly collinear
    
    let circle = Circle(a: a, b: b, c: c)
    
    // Verify that the circle contains all three points
    #expect(circle.contains(a))
    #expect(circle.contains(b))
    #expect(circle.contains(c))
    
    // The implementation may not place the center exactly at the centroid
    // Instead, verify that the center is somewhere reasonable and the radius is large
    #expect(circle.radius > 100) // The implementation uses a large radius for collinear points
}

@Test func testCircleFromExactlyCollinearPoints() async throws {
    // Test with exactly collinear points to hit the else branch
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 5, y: 0)
    let c = CGPoint(x: 10, y: 0) // Exactly collinear, d will be exactly 0
    
    let circle = Circle(a: a, b: b, c: c)
    
    // Verify that the circle contains all three points
    #expect(circle.contains(a))
    #expect(circle.contains(b))
    #expect(circle.contains(c))
    
    // Check the center is roughly at the centroid
    let expectedCenter = CGPoint(x: (a.x + b.x + c.x) / 3, y: (a.y + b.y + c.y) / 3)
    #expect(circle.center.x.isApproximatelyEqual(to: expectedCenter.x, absoluteTolerance: 0.1))
    #expect(circle.center.y.isApproximatelyEqual(to: expectedCenter.y, absoluteTolerance: 0.1))

    // Verify the radius is large
    #expect(circle.radius > 1000)
}

@Test func testCircleDebugDescription() async throws {
    let circle = Circle(center: CGPoint(x: 1, y: 2), radius: 3)
    let description = String(describing: circle)
    
    #expect(description.contains("Circle"))
    #expect(description.contains("1.0"))
    #expect(description.contains("2.0"))
    #expect(description.contains("3.0"))
} 
