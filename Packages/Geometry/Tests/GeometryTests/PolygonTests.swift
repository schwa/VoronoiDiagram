import Testing
@testable import Geometry
import CoreGraphics

@Test func testPolygonBasicInitialization() async throws {
    let vertices = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 10, y: 0),
        CGPoint(x: 10, y: 10),
        CGPoint(x: 0, y: 10)
    ]
    
    let polygon = Polygon(vertices: vertices)
    
    #expect(polygon.vertices.count == 4)
    #expect(polygon.vertices[0] == vertices[0])
    #expect(polygon.vertices[1] == vertices[1])
    #expect(polygon.vertices[2] == vertices[2])
    #expect(polygon.vertices[3] == vertices[3])
}

@Test func testPolygonInitFromSegmentsSquare() async throws {
    // Create line segments for a square
    let segments = [
        LineSegment(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 10, y: 0)),
        LineSegment(start: CGPoint(x: 10, y: 0), end: CGPoint(x: 10, y: 10)),
        LineSegment(start: CGPoint(x: 10, y: 10), end: CGPoint(x: 0, y: 10)),
        LineSegment(start: CGPoint(x: 0, y: 10), end: CGPoint(x: 0, y: 0))
    ]
    
    let polygon = Polygon(segments: segments)
    
    #expect(polygon != nil)
    if let polygon = polygon {
        #expect(polygon.vertices.count == 4)
        
        // Check that all vertices match the corners of our square
        // Note: The order might be different from our original input
        // since the algorithm can start from any segment
        let expectedPoints = Set([
            CGPoint(x: 0, y: 0),
            CGPoint(x: 10, y: 0),
            CGPoint(x: 10, y: 10),
            CGPoint(x: 0, y: 10)
        ])
        
        for vertex in polygon.vertices {
            #expect(expectedPoints.contains(vertex))
        }
    }
}

@Test func testPolygonInitFromSegmentsTriangle() async throws {
    // Create line segments for a triangle
    let segments = [
        LineSegment(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 10, y: 0)),
        LineSegment(start: CGPoint(x: 10, y: 0), end: CGPoint(x: 5, y: 10)),
        LineSegment(start: CGPoint(x: 5, y: 10), end: CGPoint(x: 0, y: 0))
    ]
    
    let polygon = Polygon(segments: segments)
    
    #expect(polygon != nil)
    if let polygon = polygon {
        #expect(polygon.vertices.count == 3)
        
        // Check that all vertices match the corners of our triangle
        let expectedPoints = Set([
            CGPoint(x: 0, y: 0),
            CGPoint(x: 10, y: 0),
            CGPoint(x: 5, y: 10)
        ])
        
        for vertex in polygon.vertices {
            #expect(expectedPoints.contains(vertex))
        }
    }
}

@Test func testPolygonInitFromSegmentsEmpty() async throws {
    // Test with empty segments array
    let polygon = Polygon(segments: [])
    
    #expect(polygon == nil)
}

@Test func testPolygonInitFromSegmentsDisconnected() async throws {
    // Create disconnected line segments
    let segments = [
        LineSegment(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 10, y: 0)),
        LineSegment(start: CGPoint(x: 20, y: 0), end: CGPoint(x: 30, y: 0)),
        LineSegment(start: CGPoint(x: 40, y: 0), end: CGPoint(x: 50, y: 0))
    ]
    
    let polygon = Polygon(segments: segments)
    
    #expect(polygon == nil, "Should fail for disconnected segments")
}

@Test func testPolygonInitFromSegmentsInsufficientConnections() async throws {
    // Create line segments with points that don't have exactly 2 connections
    // This creates a Y-shape with (10,0) having 3 connections
    let segments = [
        LineSegment(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 10, y: 0)),
        LineSegment(start: CGPoint(x: 10, y: 0), end: CGPoint(x: 20, y: 0)),
        LineSegment(start: CGPoint(x: 10, y: 0), end: CGPoint(x: 10, y: 10))
    ]
    
    let polygon = Polygon(segments: segments)
    
    #expect(polygon == nil, "Should fail when points don't have exactly 2 connections")
}

@Test func testPolygonInitFromSegmentsUnclosedLoop() async throws {
    // Create line segments that don't form a closed loop
    let segments = [
        LineSegment(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 10, y: 0)),
        LineSegment(start: CGPoint(x: 10, y: 0), end: CGPoint(x: 10, y: 10)),
        LineSegment(start: CGPoint(x: 10, y: 10), end: CGPoint(x: 5, y: 5)) // Not connecting back to (0,0)
    ]
    
    let polygon = Polygon(segments: segments)
    
    #expect(polygon == nil, "Should fail when segments don't form a closed loop")
}

@Test func testPolygonInitFromSegmentsComplexOrder() async throws {
    // Create line segments in a non-sequential order
    let segments = [
        LineSegment(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 10, y: 0)),
        LineSegment(start: CGPoint(x: 0, y: 10), end: CGPoint(x: 0, y: 0)), // Out of order
        LineSegment(start: CGPoint(x: 10, y: 10), end: CGPoint(x: 0, y: 10)), // Out of order
        LineSegment(start: CGPoint(x: 10, y: 0), end: CGPoint(x: 10, y: 10))
    ]
    
    let polygon = Polygon(segments: segments)
    
    #expect(polygon != nil)
    if let polygon = polygon {
        #expect(polygon.vertices.count == 4)
        
        // Check that all vertices match the corners of our square
        let expectedPoints = Set([
            CGPoint(x: 0, y: 0),
            CGPoint(x: 10, y: 0),
            CGPoint(x: 10, y: 10),
            CGPoint(x: 0, y: 10)
        ])
        
        for vertex in polygon.vertices {
            #expect(expectedPoints.contains(vertex))
        }
    }
}

@Test func testPolygonWithReverseSegments() async throws {
    // Create line segments with mixed directions
    let segments = [
        LineSegment(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 10, y: 0)),
        LineSegment(start: CGPoint(x: 10, y: 10), end: CGPoint(x: 10, y: 0)), // Reversed
        LineSegment(start: CGPoint(x: 10, y: 10), end: CGPoint(x: 0, y: 10)),
        LineSegment(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 10))  // Reversed
    ]
    
    let polygon = Polygon(segments: segments)
    
    #expect(polygon != nil)
    if let polygon = polygon {
        #expect(polygon.vertices.count == 4)
        
        // Check that all vertices match the corners of our square
        let expectedPoints = Set([
            CGPoint(x: 0, y: 0),
            CGPoint(x: 10, y: 0),
            CGPoint(x: 10, y: 10),
            CGPoint(x: 0, y: 10)
        ])
        
        for vertex in polygon.vertices {
            #expect(expectedPoints.contains(vertex))
        }
    }
}

@Test func testPolygonVertexOrderPreservation() async throws {
    // Test that vertices maintain the correct ordering (clockwise or counterclockwise)
    // Create line segments for a square, all flowing in the same direction
    let segments = [
        LineSegment(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 10, y: 0)),   // →
        LineSegment(start: CGPoint(x: 10, y: 0), end: CGPoint(x: 10, y: 10)),  // ↑
        LineSegment(start: CGPoint(x: 10, y: 10), end: CGPoint(x: 0, y: 10)),  // ←
        LineSegment(start: CGPoint(x: 0, y: 10), end: CGPoint(x: 0, y: 0))     // ↓
    ]
    
    let polygon = Polygon(segments: segments)
    
    #expect(polygon != nil)
    if let polygon = polygon {
        #expect(polygon.vertices.count == 4)
        
        // Since we start with (0,0) to (10,0), the vertices should be in clockwise order
        // We'll check the first vertex and then confirm the order follows our segments
        let firstVertex = polygon.vertices[0]
        let secondVertex = polygon.vertices[1]
        
        // Since we can start from any segment, find a starting point
        if firstVertex == CGPoint(x: 0, y: 0) {
            // If we start at (0,0), then the next point should be (10,0)
            #expect(secondVertex == CGPoint(x: 10, y: 0))
        } else if firstVertex == CGPoint(x: 10, y: 0) {
            #expect(secondVertex == CGPoint(x: 10, y: 10))
        } else if firstVertex == CGPoint(x: 10, y: 10) {
            #expect(secondVertex == CGPoint(x: 0, y: 10))
        } else if firstVertex == CGPoint(x: 0, y: 10) {
            #expect(secondVertex == CGPoint(x: 0, y: 0))
        }
    }
}

@Test func testPolygonWithComplexShape() async throws {
    // Test with a more complex polygon (hexagon)
    let segments = [
        LineSegment(start: CGPoint(x: 10, y: 0), end: CGPoint(x: 20, y: 10)),  // ↗
        LineSegment(start: CGPoint(x: 20, y: 10), end: CGPoint(x: 20, y: 20)), // ↑
        LineSegment(start: CGPoint(x: 20, y: 20), end: CGPoint(x: 10, y: 30)), // ↖
        LineSegment(start: CGPoint(x: 10, y: 30), end: CGPoint(x: 0, y: 20)),  // ↙
        LineSegment(start: CGPoint(x: 0, y: 20), end: CGPoint(x: 0, y: 10)),   // ↓
        LineSegment(start: CGPoint(x: 0, y: 10), end: CGPoint(x: 10, y: 0))    // ↘
    ]
    
    let polygon = Polygon(segments: segments)
    
    #expect(polygon != nil)
    if let polygon = polygon {
        #expect(polygon.vertices.count == 6)
        
        // Check that all vertices match the corners of our hexagon
        let expectedPoints = Set([
            CGPoint(x: 10, y: 0),
            CGPoint(x: 20, y: 10),
            CGPoint(x: 20, y: 20),
            CGPoint(x: 10, y: 30),
            CGPoint(x: 0, y: 20),
            CGPoint(x: 0, y: 10)
        ])
        
        for vertex in polygon.vertices {
            #expect(expectedPoints.contains(vertex))
        }
    }
} 