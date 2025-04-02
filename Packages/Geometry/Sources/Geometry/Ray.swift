import CoreGraphics
import Numerics

public struct Ray {
    public var origin: CGPoint
    public var direction: CGVector

    public init(origin: CGPoint, direction: CGVector) {
        self.origin = origin
        self.direction = direction
    }
}

extension Ray: Equatable {
}

extension Ray: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(origin.x)
        hasher.combine(origin.y)
        hasher.combine(direction.dx)
        hasher.combine(direction.dy)
    }
}

extension Ray: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Ray((\(origin, format: .point.scalarStyle(debugDescriptionNumberStyle)), (\(direction)))"
    }
} 
