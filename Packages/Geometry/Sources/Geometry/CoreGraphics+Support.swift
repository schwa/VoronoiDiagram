import CoreGraphics

public extension CGPoint {
    var norm: CGFloat {
        return hypot(x, y)
    }

    func isApproximatelyEqual(to other: Self, absoluteTolerance: CGFloat, relativeTolerance: CGFloat = 0) -> Bool {
        x.isApproximatelyEqual(to: other.x, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
        && y.isApproximatelyEqual(to: other.y, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }
}

public extension CGPoint {
    var length: CGFloat {
        return hypot(x, y)
    }

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    func dot(_ other: CGPoint) -> CGFloat {
        return x * other.x + y * other.y
    }

    func distance(to other: CGPoint) -> CGFloat {
        return (self - other).length
    }
}

// MARK: -

public extension CGRect {
    init(_ points: [CGPoint]) {
        self = .null
        points.forEach {
            self = self.union(CGRect(origin: $0, size: .zero))
        }
    }

    var minXMinY: CGPoint {
        return CGPoint(x: minX, y: minY)
    }
    var maxXMinY: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }
    var maxXMaxY: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }
    var minXMaxY: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }
    var midXMidY: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    var midXMinY: CGPoint {
        return CGPoint(x: midX, y: minY)
    }
    var midXMaxY: CGPoint {
        return CGPoint(x: midX, y: maxY)
    }
    var minXMidY: CGPoint {
        return CGPoint(x: minX, y: midY)
    }
    var maxXMidY: CGPoint {
        return CGPoint(x: maxX, y: midY)
    }
}

// MARK: -

public func isCounterClockwise(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> Bool {
    return (b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x) > 0
}

