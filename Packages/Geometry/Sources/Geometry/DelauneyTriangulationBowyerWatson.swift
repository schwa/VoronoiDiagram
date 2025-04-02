import CoreGraphics

/// Computes the Delaunay triangulation of a set of 2D points using the Bowyer-Watson algorithm. O(n log n) to O(n^2).
public func delauneyTriangulationBowyerWatson(_ points: [CGPoint], superTriangle: Triangle? = nil) -> [Triangle] {
    let superTriangle = superTriangle ?? makeSuperTriangle(from: points)
    var triangulation: Set<Triangle> = [superTriangle]

    for point in points {
        var badTriangles: Set<Triangle> = []

        for triangle in triangulation {
            if triangle.circumcircle?.contains(point) ?? false {
                badTriangles.insert(triangle)
            }
        }

        var edgeCount: [Edge: Int] = [:]
        for triangle in badTriangles {
            for edge in triangle.edges {
                edgeCount[edge.ordered, default: 0] += 1
            }
        }

        let polygonEdges = edgeCount.filter { $0.value == 1 }.map { $0.key }

        for triangle in badTriangles {
            triangulation.remove(triangle)
        }

        for edge in polygonEdges {
            let newTriangle: Triangle
            if isCounterClockwise(edge.a, edge.b, point) {
                newTriangle = Triangle(a: edge.a, b: edge.b, c: point)
            } else {
                newTriangle = Triangle(a: edge.b, b: edge.a, c: point)
            }
            triangulation.insert(newTriangle)
        }
    }

    triangulation = triangulation.filter { triangle in
        let hasA = triangle.hasVertex(superTriangle.a)
        let hasB = triangle.hasVertex(superTriangle.b)
        let hasC = triangle.hasVertex(superTriangle.c)
        return !hasA && !hasB && !hasC
    }

    return Array(triangulation)
}

/// Creates a large triangle that fully encloses the input points, suitable for initializing Bowyer-Watson triangulation with extra margin for circumcircles. O(n)
func makeSuperTriangle(from points: [CGPoint], scaleFactor: CGFloat = 1000) -> Triangle {
    guard let first = points.first else {
        fatalError("Point set must not be empty")
    }
    
    // Step 1: Compute bounding box
    var minX = first.x
    var maxX = first.x
    var minY = first.y
    var maxY = first.y
    
    for point in points {
        minX = min(minX, point.x)
        maxX = max(maxX, point.x)
        minY = min(minY, point.y)
        maxY = max(maxY, point.y)
    }
    
    // Handle the case where all points are the same (including single point case)
    let dx = maxX - minX
    let dy = maxY - minY
    
    // If the bounding box has zero width or height, create a default non-zero size
    let deltaMax = max(max(dx, dy), 1.0) // Ensure non-zero size even for single points
    
    let midX = (minX + maxX) / 2
    let midY = (minY + maxY) / 2
    
    // Step 2: Scale up to build a huge triangle around the input
    // Use different y values for a and c to ensure all vertices are different
    let a = CGPoint(x: midX - scaleFactor * deltaMax, y: midY - deltaMax)
    let b = CGPoint(x: midX,                          y: midY + scaleFactor * deltaMax)
    let c = CGPoint(x: midX + scaleFactor * deltaMax, y: midY - deltaMax * 0.5) // Different y-value than vertex a
    
    return Triangle(a: a, b: b, c: c)
}
