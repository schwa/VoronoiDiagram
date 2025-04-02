import Testing
@testable import Geometry
import CoreGraphics

// MARK: - Edge Tests

@Test func testEdge() async throws {
    // Test initialization
    let a = CGPoint(x: 0, y: 0)
    let b = CGPoint(x: 10, y: 10)
    let edge = Edge(a: a, b: b)
    
    #expect(edge.a == a)
    #expect(edge.b == b)
    
    // Test ordered
    let edge2 = Edge(a: b, b: a)
    let ordered1 = edge.ordered
    let ordered2 = edge2.ordered
    
    #expect(ordered1.a == a)
    #expect(ordered1.b == b)
    #expect(ordered2.a == a)
    #expect(ordered2.b == b)
    
    // Test equality (which uses ordered)
    #expect(edge == edge2)
    
    // Test with same y but different x
    let c = CGPoint(x: 0, y: 10)
    let d = CGPoint(x: 10, y: 10)
    let edge3 = Edge(a: c, b: d)
    let edge4 = Edge(a: d, b: c)
    
    #expect(edge3.ordered.a == c)
    #expect(edge3.ordered.b == d)
    #expect(edge4.ordered.a == c)
    #expect(edge4.ordered.b == d)
    #expect(edge3 == edge4)
    
    // Test hashable
    var dict: [Edge: String] = [:]
    dict[edge] = "edge1"
    dict[edge2] = "edge2"
    #expect(dict.count == 1)
    #expect(dict[edge] == "edge2")
} 