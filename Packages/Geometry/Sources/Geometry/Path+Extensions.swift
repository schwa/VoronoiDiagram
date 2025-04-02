import CoreGraphics
import SwiftUI

public extension Path {
    init(_ triangle: Triangle) {
        self.init { path in
            path.move(to: triangle.a)
            path.addLine(to: triangle.b)
            path.addLine(to: triangle.c)
            path.closeSubpath()
        }
    }
    init(_ circle: Circle) {
        self.init(ellipseIn: CGRect(
            x: circle.center.x - circle.radius,
            y: circle.center.y - circle.radius,
            width: circle.radius * 2,
            height: circle.radius * 2
        ))
    }

    init(_ lineSegment: LineSegment) {
        self.init { path in
            path.move(to: lineSegment.start)
            path.addLine(to: lineSegment.end)
        }
    }

    init(_ polygon: Polygon) {
        self = Path { path in
            path.addLines(polygon.vertices)
            path.closeSubpath()
        }
    }
}

