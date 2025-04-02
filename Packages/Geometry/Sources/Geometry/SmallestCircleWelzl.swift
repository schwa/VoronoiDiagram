import CoreGraphics

// https://en.wikipedia.org/wiki/Smallest-circle_problem#Welzl's_algorithm
public func smallestCircleWelzl(points: [CGPoint]) -> Circle {
    func makeCircle(points: inout [CGPoint], boundary: [CGPoint]) -> Circle {
        if points.isEmpty || boundary.count == 3 {
            return trivialCircle(from: boundary)
        }

        let point = points.removeLast()
        let circle = makeCircle(points: &points, boundary: boundary)

        if circle.contains(point) {
            points.append(point)
            return circle
        } else {
            var newBoundary = boundary
            newBoundary.append(point)
            let result = makeCircle(points: &points, boundary: newBoundary)
            points.append(point)
            return result
        }
    }

    func trivialCircle(from points: [CGPoint]) -> Circle {
        switch points.count {
        case 0:
            return Circle(center: .zero, radius: 0)
        case 1:
            return Circle(center: points[0], radius: 0)
        case 2:
            let pointA = points[0]
            let pointB = points[1]
            let center = CGPoint(x: (pointA.x + pointB.x) / 2, y: (pointA.y + pointB.y) / 2)
            let radius = hypot(pointA.x - pointB.x, pointA.y - pointB.y) / 2
            return Circle(center: center, radius: radius)
        case 3:
            return Circle(a: points[0], b: points[1], c: points[2])
        default:
            fatalError("More than 3 boundary points in trivialCircle")
        }
    }

    precondition(points.count > 0, "Cannot fit circle to empty array")

    var result = Circle(center: .zero, radius: 0)

    // If only one point, radius is zero
    if points.count == 1 {
        result.center = points[0]
        result.radius = 0
        return result
    }

    // If only two points, return circle with center at midpoint and radius half the distance
    if points.count == 2 {
        let pointA = points[0]
        let pointB = points[1]
        let center = CGPoint(x: (pointA.x + pointB.x) / 2, y: (pointA.y + pointB.y) / 2)
        let radius = hypot(pointA.x - pointB.x, pointA.y - pointB.y) / 2
        result.center = center
        result.radius = radius
        return result
    }

    // Otherwise, use Welzl's algorithm (simplified version)
    var shuffledPoints = points.shuffled()
    return makeCircle(points: &shuffledPoints, boundary: [])
}
