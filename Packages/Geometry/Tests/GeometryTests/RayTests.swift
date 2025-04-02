import Testing
@testable import Geometry
import CoreGraphics

// MARK: - Ray Tests

@Test func testRay() async throws {
    // Test initialization
    let origin = CGPoint(x: 1, y: 2)
    let direction = CGVector(dx: 3, dy: 4)
    let ray = Ray(origin: origin, direction: direction)
    
    #expect(ray.origin == origin)
    #expect(ray.direction == direction)
    
    // Test equality
    let ray2 = Ray(origin: origin, direction: direction)
    #expect(ray == ray2)
    
    let ray3 = Ray(origin: CGPoint(x: 2, y: 2), direction: direction)
    #expect(ray != ray3)
    
    // Test hashable
    var dict: [Ray: String] = [:]
    dict[ray] = "ray1"
    dict[ray2] = "ray2"
    #expect(dict.count == 1)
    #expect(dict[ray] == "ray2")
    
    // Test description
    let description = ray.debugDescription
    #expect(description.contains("Ray"))
    #expect(description.contains("1.0"))
    #expect(description.contains("2.0"))
    #expect(description.contains("3.0"))
    #expect(description.contains("4.0"))
} 