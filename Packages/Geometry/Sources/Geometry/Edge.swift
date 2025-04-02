import CoreGraphics
import Numerics

public struct Edge {
    public var a: CGPoint
    public var b: CGPoint

    public init(a: CGPoint, b: CGPoint) {
        self.a = a
        self.b = b
    }
}

extension Edge: Equatable {
    public static func ==(lhs: Edge, rhs: Edge) -> Bool {
        let lhs = lhs.ordered
        let rhs = rhs.ordered
        return lhs.a == rhs.a && lhs.b == rhs.b
    }
}

extension Edge: Hashable {
    public func hash(into hasher: inout Hasher) {
        let ordered = ordered
        hasher.combine(ordered.a.x)
        hasher.combine(ordered.a.y)
        hasher.combine(ordered.b.x)
        hasher.combine(ordered.b.y)
    }
}

public extension Edge {
    var ordered: Edge {
        let (first, second): (CGPoint, CGPoint)
        if a.x < b.x || (a.x == b.x && a.y <= b.y) {
            first = a
            second = b
        } else {
            first = b
            second = a
        }
        return Edge(a: first, b: second)
    }
} 