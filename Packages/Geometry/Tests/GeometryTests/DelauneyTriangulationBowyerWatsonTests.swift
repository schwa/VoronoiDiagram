import Testing
@testable import Geometry
import CoreGraphics
import Numerics

@Test func delauneyTriangulationBowyerWatsonGood() async throws {
    let points: [CGPoint] = [
        CGPoint(x: 0.8, y: 0.6),
        CGPoint(x: 0.8, y: 0.4),
        CGPoint(x: 0.2, y: 0.4),
        CGPoint(x: 0.2, y: 0.6),
        CGPoint(x: 0.50001, y: 0.5),
    ]
    let triangles = delauneyTriangulationBowyerWatson(points)
    #expect(triangles.count == 4)
}

@Test func delauneyTriangulationBowyerWatsonBad() async throws {
    let points: [CGPoint] = [
        CGPoint(x: 0.8, y: 0.6),
        CGPoint(x: 0.8, y: 0.4),
        CGPoint(x: 0.2, y: 0.4),
        CGPoint(x: 0.2, y: 0.6),
        CGPoint(x: 0.5, y: 0.5),
    ]
    let triangles = delauneyTriangulationBowyerWatson(points)
    #expect(triangles.count == 4)
}

// MARK: - Component Tests

@Test func testMakeSuperTriangle() async throws {
    // Test with square points
    let squarePoints: [CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 10),
        CGPoint(x: 10, y: 0),
        CGPoint(x: 10, y: 10)
    ]
    
    let superTriangle = makeSuperTriangle(from: squarePoints, scaleFactor: 100)
    
    // Verify the super triangle is much larger than the input points
    #expect(superTriangle.a.x < 0)
    #expect(superTriangle.a.y < 0)
    #expect(superTriangle.b.y > 10)
    #expect(superTriangle.c.x > 10)
    
    // Test with single point
    let singlePoint: [CGPoint] = [CGPoint(x: 5, y: 5)]
    let superTriangleSingle = makeSuperTriangle(from: singlePoint, scaleFactor: 100)
    
    // Verify the super triangle still creates a valid triangle for a single point
    #expect(superTriangleSingle.a.x != superTriangleSingle.b.x)
    #expect(superTriangleSingle.a.y != superTriangleSingle.c.y)
}

@Test func testTriangleCircumcircle() async throws {
    // Test a right triangle
    let rightTriangle = Triangle(a: CGPoint(x: 0, y: 0), 
                                b: CGPoint(x: 0, y: 1), 
                                c: CGPoint(x: 1, y: 0))
    
    let circle = rightTriangle.circumcircle
    #expect(circle != nil)
    
    if let circle = circle {
        // The center of the circumcircle should be at (0.5, 0.5)
        #expect(circle.center.x.isApproximatelyEqual(to: 0.5, absoluteTolerance: 1e-10))
        #expect(circle.center.y.isApproximatelyEqual(to: 0.5, absoluteTolerance: 1e-10))

        // The radius should be 0.5√2
        #expect(circle.radius.isApproximatelyEqual(to: 0.5 * sqrt(2), absoluteTolerance: 1e-10))
        
        // Points on the triangle should be on the circumcircle
        #expect(circle.contains(rightTriangle.a))
        #expect(circle.contains(rightTriangle.b))
        #expect(circle.contains(rightTriangle.c))
        
        // The center of the triangle should be inside the circumcircle
        #expect(circle.contains(CGPoint(x: 0.3, y: 0.3)))
    }
    
    // Test a degenerate (collinear) triangle
    let degenerateTriangle = Triangle(a: CGPoint(x: 0, y: 0),
                                     b: CGPoint(x: 1, y: 1),
                                     c: CGPoint(x: 2, y: 2))
    
    let degenerateCircle = degenerateTriangle.circumcircle
    #expect(degenerateCircle == nil, "Collinear points should not have a circumcircle")
}

@Test func testEdgeOrdering() async throws {
    // Test edge ordering
    let edge1 = Edge(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 1, y: 1))
    let edge2 = Edge(a: CGPoint(x: 1, y: 1), b: CGPoint(x: 0, y: 0))
    
    // Both edges should be considered the same after ordering
    #expect(edge1.ordered == edge2.ordered)
    
    // The ordered edge should have the lexicographically smaller point first
    #expect(edge1.ordered.a.x == 0)
    #expect(edge1.ordered.a.y == 0)
    
    // Test another case where y-comparison matters
    let edge3 = Edge(a: CGPoint(x: 1, y: 2), b: CGPoint(x: 1, y: 0))
    let edge4 = Edge(a: CGPoint(x: 1, y: 0), b: CGPoint(x: 1, y: 2))
    
    #expect(edge3.ordered == edge4.ordered)
    #expect(edge3.ordered.a.y == 0)
}

// Test the isCounterClockwise function used in triangle creation
@Test func testIsCounterClockwise() async throws {
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 1, y: 0)
    let c1 = CGPoint(x: 0.5, y: 1) // Counterclockwise
    let c2 = CGPoint(x: 0.5, y: -1) // Clockwise
    
    #expect(isCounterClockwise(a, b, c1) == true)
    #expect(isCounterClockwise(a, b, c2) == false)
    
    // Collinear points
    let c3 = CGPoint(x: 2, y: 0)
    #expect(isCounterClockwise(a, b, c3) == false, "Collinear points should not be considered counterclockwise")
}
