import CoreGraphics

/// Finds the pair of points on a convex polygon (the convex hull) that are farthest apart—i.e., the diameter of the convex hull. O(n).
public func farthestPairRotatingCalipers(on hull: [CGPoint]) -> (CGPoint, CGPoint)? {
    guard hull.count >= 2 else {
        return nil
    }
    var maxDistanceSquared: CGFloat = 0
    var result: (CGPoint, CGPoint) = (hull[0], hull[1])
    var j = 1
    for i in 0..<hull.count {
        let currentPoint = hull[i]
        var nextJ = j
        while true {
            let next = (nextJ + 1) % hull.count
            let area1 = abs(cross(currentPoint, hull[nextJ], hull[(nextJ + 1) % hull.count]))
            let area2 = abs(cross(currentPoint, hull[next], hull[(next + 1) % hull.count]))
            if area2 > area1 {
                nextJ = next
            } else {
                break
            }
        }
        let candidate = hull[nextJ]
        let distSq = distanceSquared(currentPoint, candidate)
        if distSq > maxDistanceSquared {
            maxDistanceSquared = distSq
            result = (currentPoint, candidate)
        }
        j = nextJ
    }
    return result
}
