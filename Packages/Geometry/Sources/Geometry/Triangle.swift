import CoreGraphics
import Numerics

public struct Triangle {
    public var a: CGPoint
    public var b: CGPoint
    public var c: CGPoint
    
    public init(a: CGPoint, b: CGPoint, c: CGPoint) {
        self.a = a
        self.b = b
        self.c = c
    }
}

extension Triangle: Equatable {
}

extension Triangle: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(a.x)
        hasher.combine(a.y)
        hasher.combine(b.x)
        hasher.combine(b.y)
        hasher.combine(c.x)
        hasher.combine(c.y)
    }
}

extension Triangle: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Triangle(a: \(a), b: \(b), c: \(c))"
    }
}

public extension Triangle {
    init(fitting circle: Circle) {
        let r = circle.radius
        let center = circle.center

        let angle1 = CGFloat(0)
        let angle2 = CGFloat(2 * CGFloat.pi / 3)
        let angle3 = CGFloat(4 * CGFloat.pi / 3)

        let a = CGPoint(
            x: center.x + r * cos(angle1),
            y: center.y + r * sin(angle1)
        )
        let b = CGPoint(
            x: center.x + r * cos(angle2),
            y: center.y + r * sin(angle2)
        )
        let c = CGPoint(
            x: center.x + r * cos(angle3),
            y: center.y + r * sin(angle3)
        )

        self.init(a: a, b: b, c: c)
    }

    func hasVertex(_ point: CGPoint, absoluteTolerance: CGFloat = 0, relativeTolerance: CGFloat = 0) -> Bool {
        a.isApproximatelyEqual(to: point, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
        || b.isApproximatelyEqual(to: point, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
        || c.isApproximatelyEqual(to: point, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }

    func contains(_ point: CGPoint) -> Bool {
        // Compute barycentric coordinates
        let denominator = ((b.y - c.y) * (a.x - c.x) + (c.x - b.x) * (a.y - c.y))
        let alpha = ((b.y - c.y) * (point.x - c.x) + (c.x - b.x) * (point.y - c.y)) / denominator
        let beta = ((c.y - a.y) * (point.x - c.x) + (a.x - c.x) * (point.y - c.y)) / denominator
        let gamma = 1 - alpha - beta
        // Point is inside if all coordinates are positive
        return alpha > 0 && beta > 0 && gamma > 0
    }

    var edges: [Edge] {
        return [
            Edge(a: a, b: b),
            Edge(a: b, b: c),
            Edge(a: c, b: a)
        ]
    }

    var circumcircle: Circle? {
        let D = 2 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))
        guard abs(D) > 1e-10 else {
            // Points are nearly collinear; circumcircle is undefined
            return nil
        }
        let A_sq = a.x * a.x + a.y * a.y
        let B_sq = b.x * b.x + b.y * b.y
        let C_sq = c.x * c.x + c.y * c.y
        let ux = (A_sq * (b.y - c.y) + B_sq * (c.y - a.y) + C_sq * (a.y - b.y)) / D
        let uy = (A_sq * (c.x - b.x) + B_sq * (a.x - c.x) + C_sq * (b.x - a.x)) / D
        let center = CGPoint(x: ux, y: uy)
        let radius = sqrt((ux - a.x) * (ux - a.x) + (uy - a.y) * (uy - a.y))
        return Circle(center: center, radius: radius)
    }

    static func superTriangle(of rect: CGRect) -> Triangle {
        let center = rect.midXMidY
        let radius = center.distance(to: rect.maxXMaxY)
        let a = CGPoint(x: center.x - 2 * radius, y: center.y - radius * sqrt(3))
        let b = CGPoint(x: center.x, y: center.y + 2 * radius)
        let c = CGPoint(x: center.x + 2 * radius, y: center.y - radius * sqrt(3))
        return Triangle(a: a, b: b, c: c)
    }

    var winding: Winding {
        let area = (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)
        if area > 0 {
            return .counterClockwise
        } else if area < 0 {
            return .clockwise
        } else {
            return .colinear
        }
    }

    enum Vertex {
        case a
        case b
        case c
    }

    /// Returns a triangle with the same winding but rotated so the top-leftmost vertex comes first.
    var standardized: Triangle {
        let vertex: Vertex
        if a.y < b.y || (a.y == b.y && a.x < b.x) {
            if a.y < c.y || (a.y == c.y && a.x < c.x) {
                vertex = .a
            } else {
                vertex = .c
            }
        } else {
            if b.y < c.y || (b.y == c.y && b.x < c.x) {
                vertex = .b
            } else {
                vertex = .c
            }
        }
        switch vertex {
        case .a: return self // a is smallest
        case .b: return Triangle(a: b, b: c, c: a)
        case .c: return Triangle(a: c, b: a, c: b)
        }
    }
} 
