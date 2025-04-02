import Testing
@testable import Geometry
import CoreGraphics
import Numerics

@Test func testEquilateralTriangleCircumcircle() async throws {
    // Equilateral triangle's circumcircle center is at the centroid
    let side = 10.0
    let height = side * sqrt(3) / 2
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: side, y: 0)
    let c = CGPoint(x: side/2, y: height)
    
    let triangle = Triangle(a: a, b: b, c: c)
    let circumcircle = triangle.circumcircle
    
    #expect(circumcircle != nil)
    if let circle = circumcircle {
        // Center should be at (5, 2.89)
        #expect(circle.center.x.isApproximatelyEqual(to: side/2, absoluteTolerance: 1e-6))
        #expect(circle.center.y.isApproximatelyEqual(to: height/3, absoluteTolerance: 1e-6))
        
        // Radius for equilateral triangle is side/(sqrt(3))
        #expect(circle.radius.isApproximatelyEqual(to: side/sqrt(3), absoluteTolerance: 1e-6))
        
        // All vertices should be on the circle
        #expect(circle.contains(a))
        #expect(circle.contains(b))
        #expect(circle.contains(c))
        
        // Check that all vertices are equidistant from center
        let dist1 = distance(circle.center, a)
        let dist2 = distance(circle.center, b)
        let dist3 = distance(circle.center, c)
        
        #expect(dist1.isApproximatelyEqual(to: circle.radius, absoluteTolerance: 1e-6))
        #expect(dist2.isApproximatelyEqual(to: circle.radius, absoluteTolerance: 1e-6))
        #expect(dist3.isApproximatelyEqual(to: circle.radius, absoluteTolerance: 1e-6))
    }
}

@Test func testRightTriangleCircumcircle() async throws {
    // For a right triangle, the center of the circumcircle is at the midpoint of the hypotenuse
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 0, y: 4)  // Right angle at a
    let c = CGPoint(x: 3, y: 0)
    
    let triangle = Triangle(a: a, b: b, c: c)
    let circumcircle = triangle.circumcircle
    
    #expect(circumcircle != nil)
    if let circle = circumcircle {
        // The center should be at the midpoint of the hypotenuse
        #expect(circle.center.x.isApproximatelyEqual(to: 1.5, absoluteTolerance: 1e-6))
        #expect(circle.center.y.isApproximatelyEqual(to: 2.0, absoluteTolerance: 1e-6))
        
        // Radius should be half the length of the hypotenuse
        let hypotenuseLength = distance(b, c)
        #expect(circle.radius.isApproximatelyEqual(to: hypotenuseLength/2, absoluteTolerance: 1e-6))
        
        // All vertices should be on the circle
        #expect(circle.contains(a))
        #expect(circle.contains(b))
        #expect(circle.contains(c))
    }
}

@Test func testObtuseTriangleCircumcircle() async throws {
    // Test an obtuse triangle (one angle > 90°)
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 10, y: 0)
    let c = CGPoint(x: 2, y: 3)  // Creates an obtuse angle at b
    
    let triangle = Triangle(a: a, b: b, c: c)
    let circumcircle = triangle.circumcircle
    
    #expect(circumcircle != nil)
    if let circle = circumcircle {
        // Instead of checking exact coordinates, let's verify the fundamental properties:
        
        // All vertices should be on the circle
        #expect(circle.contains(a))
        #expect(circle.contains(b))
        #expect(circle.contains(c))
        
        // Distances from center to all vertices should be equal
        let dist1 = distance(circle.center, a)
        let dist2 = distance(circle.center, b)
        let dist3 = distance(circle.center, c)
        
        #expect(dist1.isApproximatelyEqual(to: dist2, absoluteTolerance: 1e-6))
        #expect(dist2.isApproximatelyEqual(to: dist3, absoluteTolerance: 1e-6))
        #expect(dist3.isApproximatelyEqual(to: dist1, absoluteTolerance: 1e-6))
    }
}

@Test func testAcuteTriangleCircumcircle() async throws {
    // Test an acute triangle (all angles < 90°)
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 4, y: 0)
    let c = CGPoint(x: 2, y: 3)
    
    let triangle = Triangle(a: a, b: b, c: c)
    let circumcircle = triangle.circumcircle
    
    #expect(circumcircle != nil)
    if let circle = circumcircle {
        // All vertices should be on the circle
        #expect(circle.contains(a))
        #expect(circle.contains(b))
        #expect(circle.contains(c))
        
        // Distances from center to all vertices should be equal to the radius
        let dist1 = distance(circle.center, a)
        let dist2 = distance(circle.center, b)
        let dist3 = distance(circle.center, c)
        
        #expect(dist1.isApproximatelyEqual(to: circle.radius, absoluteTolerance: 1e-6))
        #expect(dist2.isApproximatelyEqual(to: circle.radius, absoluteTolerance: 1e-6))
        #expect(dist3.isApproximatelyEqual(to: circle.radius, absoluteTolerance: 1e-6))
    }
}

@Test func testIsoscelesTriangleCircumcircle() async throws {
    // Test an isosceles triangle (two sides equal)
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 6, y: 0)
    let c = CGPoint(x: 3, y: 4)  // Creates equal sides ac and bc
    
    let triangle = Triangle(a: a, b: b, c: c)
    let circumcircle = triangle.circumcircle
    
    #expect(circumcircle != nil)
    if let circle = circumcircle {
        // For an isosceles triangle, the center should be on the altitude to the unequal side
        #expect(circle.center.x.isApproximatelyEqual(to: 3.0, absoluteTolerance: 1e-6))
        
        // All vertices should be on the circle
        #expect(circle.contains(a))
        #expect(circle.contains(b))
        #expect(circle.contains(c))
    }
}

@Test func testScaledTriangleCircumcircle() async throws {
    // Test that scaling a triangle scales its circumcircle proportionally
    let smallTriangle = Triangle(
        a: CGPoint(x: 0, y: 0),
        b: CGPoint(x: 1, y: 0),
        c: CGPoint(x: 0, y: 1)
    )
    
    let largeTriangle = Triangle(
        a: CGPoint(x: 0, y: 0),
        b: CGPoint(x: 10, y: 0),
        c: CGPoint(x: 0, y: 10)
    )
    
    let smallCircle = smallTriangle.circumcircle
    let largeCircle = largeTriangle.circumcircle
    
    #expect(smallCircle != nil)
    #expect(largeCircle != nil)
    
    if let small = smallCircle, let large = largeCircle {
        // The ratio of radii should be the same as the scaling factor
        #expect((large.radius / small.radius).isApproximatelyEqual(to: 10.0, absoluteTolerance: 1e-6))
    }
}

@Test func testTranslatedTriangleCircumcircle() async throws {
    // Test that translating a triangle translates its circumcircle
    let triangle1 = Triangle(
        a: CGPoint(x: 0, y: 0),
        b: CGPoint(x: 4, y: 0),
        c: CGPoint(x: 2, y: 3)
    )
    
    let offset = CGPoint(x: 100, y: 200)
    let triangle2 = Triangle(
        a: CGPoint(x: triangle1.a.x + offset.x, y: triangle1.a.y + offset.y),
        b: CGPoint(x: triangle1.b.x + offset.x, y: triangle1.b.y + offset.y),
        c: CGPoint(x: triangle1.c.x + offset.x, y: triangle1.c.y + offset.y)
    )
    
    let circle1 = triangle1.circumcircle
    let circle2 = triangle2.circumcircle
    
    #expect(circle1 != nil)
    #expect(circle2 != nil)
    
    if let c1 = circle1, let c2 = circle2 {
        // The radii should be the same
        #expect(c1.radius.isApproximatelyEqual(to: c2.radius, absoluteTolerance: 1e-6))
        
        // The center should be offset by the same amount as the triangle
        #expect((c2.center.x - c1.center.x).isApproximatelyEqual(to: offset.x, absoluteTolerance: 1e-6))
        #expect((c2.center.y - c1.center.y).isApproximatelyEqual(to: offset.y, absoluteTolerance: 1e-6))
    }
}

@Test func testNearlyCollinearTriangleCircumcircle() async throws {
    // Test a nearly collinear triangle (almost a line)
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 10, y: 0)
    let c = CGPoint(x: 5, y: 0.001)  // Almost collinear
    
    let triangle = Triangle(a: a, b: b, c: c)
    let circumcircle = triangle.circumcircle
    
    #expect(circumcircle != nil)
    if let circle = circumcircle {
        // The center should be approximately at (5, 12500)
        // The radius should be very large (approximately 12500)
        // This is because as points get closer to collinear, the circumcircle becomes larger
        
        // All vertices should be on the circle
        #expect(circle.contains(a))
        #expect(circle.contains(b))
        #expect(circle.contains(c))
        
        // Distances from center to all vertices should be equal
        let dist1 = distance(circle.center, a)
        let dist2 = distance(circle.center, b)
        let dist3 = distance(circle.center, c)
        
        #expect(dist1.isApproximatelyEqual(to: dist2, absoluteTolerance: 1e-3))
        #expect(dist2.isApproximatelyEqual(to: dist3, absoluteTolerance: 1e-3))
        #expect(dist3.isApproximatelyEqual(to: dist1, absoluteTolerance: 1e-3))
    }
}

@Test func testExactlyCollinearTriangleCircumcircle() async throws {
    // Test an exactly collinear triangle (points in a line)
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 5, y: 0)
    let c = CGPoint(x: 10, y: 0)
    
    let triangle = Triangle(a: a, b: b, c: c)
    let circumcircle = triangle.circumcircle
    
    // Circumcircle should be nil for collinear points
    #expect(circumcircle == nil)
}

@Test func testLargeCoordinatesCircumcircle() async throws {
    // Test triangle with very large coordinates to check numerical stability
    let a = CGPoint(x: 10000, y: 10000)
    let b = CGPoint(x: 10010, y: 10000)
    let c = CGPoint(x: 10005, y: 10008)
    
    let triangle = Triangle(a: a, b: b, c: c)
    let circumcircle = triangle.circumcircle
    
    #expect(circumcircle != nil)
    if let circle = circumcircle {
        // All vertices should be on the circle
        #expect(circle.contains(a))
        #expect(circle.contains(b))
        #expect(circle.contains(c))
        
        // Distances from center to all vertices should be equal
        let dist1 = distance(circle.center, a)
        let dist2 = distance(circle.center, b)
        let dist3 = distance(circle.center, c)
        
        #expect(dist1.isApproximatelyEqual(to: dist2, absoluteTolerance: 1e-3))
        #expect(dist2.isApproximatelyEqual(to: dist3, absoluteTolerance: 1e-3))
        #expect(dist3.isApproximatelyEqual(to: dist1, absoluteTolerance: 1e-3))
    }
}

@Test func testSmallCoordinatesCircumcircle() async throws {
    // Test triangle with very small coordinates to check numerical stability
    // These need to be sufficiently far from zero to avoid collinearity issues
    let a = CGPoint(x: 0.00001, y: 0.00001)
    let b = CGPoint(x: 0.00003, y: 0.00001)
    let c = CGPoint(x: 0.00002, y: 0.00004)
    
    let triangle = Triangle(a: a, b: b, c: c)
    let circumcircle = triangle.circumcircle
    
    #expect(circumcircle != nil)
    if let circle = circumcircle {
        // All vertices should be on the circle
        #expect(circle.contains(a))
        #expect(circle.contains(b))
        #expect(circle.contains(c))
        
        // Distances from center to all vertices should be equal
        let dist1 = distance(circle.center, a)
        let dist2 = distance(circle.center, b)
        let dist3 = distance(circle.center, c)
        
        #expect(dist1.isApproximatelyEqual(to: dist2, absoluteTolerance: 1e-10))
        #expect(dist2.isApproximatelyEqual(to: dist3, absoluteTolerance: 1e-10))
        #expect(dist3.isApproximatelyEqual(to: dist1, absoluteTolerance: 1e-10))
    }
}

@Test func testRandomTrianglesCircumcircle() async throws {
    // Test a number of random triangles to ensure general correctness
    // Create 10 random triangles
    for _ in 0..<10 {
        let a = CGPoint(x: CGFloat.random(in: -100...100), y: CGFloat.random(in: -100...100))
        var b = CGPoint(x: CGFloat.random(in: -100...100), y: CGFloat.random(in: -100...100))
        var c = CGPoint(x: CGFloat.random(in: -100...100), y: CGFloat.random(in: -100...100))
        
        // Ensure points aren't collinear (add a minimum area constraint)
        while abs(signedArea(a: a, b: b, c: c)) < 1.0 {
            b = CGPoint(x: CGFloat.random(in: -100...100), y: CGFloat.random(in: -100...100))
            c = CGPoint(x: CGFloat.random(in: -100...100), y: CGFloat.random(in: -100...100))
        }
        
        let triangle = Triangle(a: a, b: b, c: c)
        let circumcircle = triangle.circumcircle
        
        #expect(circumcircle != nil)
        if let circle = circumcircle {
            // All vertices should be on the circle
            #expect(circle.contains(a))
            #expect(circle.contains(b))
            #expect(circle.contains(c))
            
            // Distances from center to all vertices should be equal to the radius
            let dist1 = distance(circle.center, a)
            let dist2 = distance(circle.center, b)
            let dist3 = distance(circle.center, c)
            
            #expect(dist1.isApproximatelyEqual(to: circle.radius, absoluteTolerance: 1e-5))
            #expect(dist2.isApproximatelyEqual(to: circle.radius, absoluteTolerance: 1e-5))
            #expect(dist3.isApproximatelyEqual(to: circle.radius, absoluteTolerance: 1e-5))
        }
    }
} 