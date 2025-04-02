import CoreGraphics
import SwiftUI

public enum Winding {
    case clockwise
    case counterClockwise
    case colinear
}

// Cross product of vectors (a->b) and (a->c)
public func cross(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> CGFloat {
    let abx = b.x - a.x
    let aby = b.y - a.y
    let acx = c.x - a.x
    let acy = c.y - a.y
    return abx * acy - aby * acx
}

public func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    return hypot(a.x - b.x, a.y - b.y)
}

public func distanceSquared(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let dx = a.x - b.x
    let dy = a.y - b.y
    return dx * dx + dy * dy
}

public func signedArea(a: CGPoint, b: CGPoint, c: CGPoint) -> CGFloat {
    return 0.5 * ((b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y))
}

extension CGVector {
    var normalized: CGVector {
        let length = hypot(dx, dy)
        guard length > 0 else { return CGVector(dx: 0, dy: 0) }
        return CGVector(dx: dx / length, dy: dy / length)
    }
}

public func angle(from center: CGPoint, to point: CGPoint) -> Angle {
    .radians(atan2(point.y - center.y, point.x - center.x))
}
