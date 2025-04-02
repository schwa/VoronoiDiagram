import CoreGraphics
import Numerics

public struct Circle {
    public var center: CGPoint
    public var radius: CGFloat

    public init(center: CGPoint, radius: CGFloat) {
        self.center = center
        self.radius = radius
    }
}

extension Circle: Equatable {
}

public extension Circle {
    func contains(_ point: CGPoint) -> Bool {
        let dx = point.x - center.x
        let dy = point.y - center.y
        let distanceSquared = dx * dx + dy * dy
        let squaredRadius = radius * radius
        return distanceSquared < squaredRadius || abs(distanceSquared - squaredRadius) < 1e-8
    }

    init(a: CGPoint, b: CGPoint, c: CGPoint) {
        let d = 2 * (a.x * (b.y - c.y) +
                     b.x * (c.y - a.y) +
                     c.x * (a.y - b.y))
        if abs(d) > 1e-10 {
            let ux = ((a.x * a.x + a.y * a.y) * (b.y - c.y) +
                      (b.x * b.x + b.y * b.y) * (c.y - a.y) +
                      (c.x * c.x + c.y * c.y) * (a.y - b.y)) / d
            let uy = ((a.x * a.x + a.y * a.y) * (c.x - b.x) +
                      (b.x * b.x + b.y * b.y) * (a.x - c.x) +
                      (c.x * c.x + c.y * c.y) * (b.x - a.x)) / d
            let center = CGPoint(x: ux, y: uy)
            let radius = hypot(center.x - a.x, center.y - a.y)
            self.init(center: center, radius: radius)
        } else {
            // Points are nearly collinear, create a circle with a very large radius
            let center = CGPoint(x: (a.x + b.x + c.x) / 3, y: (a.y + b.y + c.y) / 3)
            let radius = max(
                hypot(center.x - a.x, center.y - a.y),
                hypot(center.x - b.x, center.y - b.y),
                hypot(center.x - c.x, center.y - c.y)
            ) * 1000
            self.init(center: center, radius: radius)
        }
    }
} 
