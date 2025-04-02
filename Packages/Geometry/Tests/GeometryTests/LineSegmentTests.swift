import Testing
@testable import Geometry
import CoreGraphics
import Numerics

// MARK: - LineSegment Tests

@Test func testLineSegment() async throws {
    // Test initialization
    let start = CGPoint(x: 1, y: 2)
    let end = CGPoint(x: 3, y: 4)
    let segment = LineSegment(start: start, end: end)
    
    #expect(segment.start == start)
    #expect(segment.end == end)
    
    // Test equality
    let segment2 = LineSegment(start: start, end: end)
    #expect(segment == segment2)
    
    let segment3 = LineSegment(start: CGPoint(x: 1, y: 1), end: end)
    #expect(segment != segment3)
    
    // Test hashable
    var dict: [LineSegment: String] = [:]
    dict[segment] = "segment1"
    dict[segment2] = "segment2"
    #expect(dict.count == 1)
    #expect(dict[segment] == "segment2")
    
    // Test description
    let description = segment.debugDescription
    #expect(description.contains("LineSegment"))
    #expect(description.contains("1.0"))
    #expect(description.contains("2.0"))
    #expect(description.contains("3.0"))
    #expect(description.contains("4.0"))
}

@Test func testLineSegmentFromRay() async throws {
    let origin = CGPoint(x: 0, y: 0)
    let direction = CGVector(dx: 1, dy: 1)
    let ray = Ray(origin: origin, direction: direction)
    let length: CGFloat = 5.0 * sqrt(2)  // sqrt(2) for a 45 degree angle to go 5 units along each axis
    
    let segment = LineSegment(ray: ray, maxLength: length)
    
    #expect(segment.start == origin)
    #expect(segment.end.x.isApproximatelyEqual(to: 5.0, absoluteTolerance: 1e-5))
    #expect(segment.end.y.isApproximatelyEqual(to: 5.0, absoluteTolerance: 1e-5))
}

@Test func testLineSegmentOtherPoint() async throws {
    let start = CGPoint(x: 1, y: 2)
    let end = CGPoint(x: 3, y: 4)
    let segment = LineSegment(start: start, end: end)
    
    // Test getting the end point when providing the start point
    let otherFromStart = segment.otherPoint(start)
    #expect(otherFromStart == end)
    
    // Test getting the start point when providing the end point
    let otherFromEnd = segment.otherPoint(end)
    #expect(otherFromEnd == start)
    
    // Test with a point that's not on the segment
    let unrelatedPoint = CGPoint(x: 10, y: 10)
    let otherFromUnrelated = segment.otherPoint(unrelatedPoint)
    #expect(otherFromUnrelated == start, "otherPoint should return start if the point doesn't match either endpoint")
    
    // Test with a point that's very close to start but not exactly equal
    let almostStart = CGPoint(x: 1.0000001, y: 2.0000001)
    let otherFromAlmostStart = segment.otherPoint(almostStart)
    #expect(otherFromAlmostStart == start, "otherPoint uses exact equality, not approximate equality")
}
