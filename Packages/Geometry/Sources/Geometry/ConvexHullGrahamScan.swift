import CoreGraphics

/// Find the convex hull of a set of points using the Graham scan algorithm. O(n log n).
public func convexHullGrahamScan(points: [CGPoint]) -> [CGPoint] {
    guard points.count >= 3 else {
        return points
    }
    let startPoint = points.min { (a, b) -> Bool in
        if a.y == b.y {
            return a.x < b.x
        } else {
            return a.y < b.y
        }
    }!
    let sortedPoints = points.sorted { (a, b) -> Bool in
        let angleA = atan2(a.y - startPoint.y, a.x - startPoint.x)
        let angleB = atan2(b.y - startPoint.y, b.x - startPoint.x)
        if angleA == angleB {
            // Closer point comes first if angle is same
            let distA = hypot(a.x - startPoint.x, a.y - startPoint.y)
            let distB = hypot(b.x - startPoint.x, b.y - startPoint.y)
            return distA < distB
        }
        return angleA < angleB
    }
    var hull: [CGPoint] = []
    for point in sortedPoints {
        while hull.count >= 2 &&
              cross(hull[hull.count - 2], hull[hull.count - 1], point) <= 0 {
            hull.removeLast()
        }
        hull.append(point)
    }
    return hull
}
