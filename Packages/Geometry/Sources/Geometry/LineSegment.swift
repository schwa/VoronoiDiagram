import CoreGraphics
import Numerics
import SwiftFormats
import Foundation

public struct LineSegment {
    public var start: CGPoint
    public var end: CGPoint

    public init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
}

extension LineSegment: Equatable {
}

extension CGPointFormatStyle {
        func scalarStyle(_ scalarStyle: FloatingPointFormatStyle<Double>) -> Self {
            var copy = self
            copy.componentFormat = scalarStyle
            return copy
        }
}

extension LineSegment: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(start.x)
        hasher.combine(start.y)
        hasher.combine(end.x)
        hasher.combine(end.y)
    }
}

let debugDescriptionNumberStyle = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(3))

extension LineSegment: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "LineSegment((\(start, format: .point.scalarStyle(debugDescriptionNumberStyle)), (\(end, format: .point.scalarStyle(debugDescriptionNumberStyle))))"
    }
}

public extension LineSegment {
    init(ray: Ray, maxLength: CGFloat) {
        let start = ray.origin
        let directionNormalized = ray.direction.normalized
        let end = CGPoint(
            x: ray.origin.x + directionNormalized.dx * maxLength,
            y: ray.origin.y + directionNormalized.dy * maxLength
        )
        self = LineSegment(start: start, end: end)
    }
} 

extension LineSegment {
    func otherPoint(_ point: CGPoint) -> CGPoint {
        if start == point {
            return end
        } else {
            return start
        }
    }
}


