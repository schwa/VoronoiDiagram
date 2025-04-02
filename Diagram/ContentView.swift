import SwiftUI
import CoreTransferable
import UniformTypeIdentifiers
import Geometry

struct ContentView: View {
    struct Options {
        var drawConvexHull: Bool = true
        var drawTriangulation: Bool = true
        var drawCircumcircles: Bool = true
        var drawVoronoi: Bool = true
        var drawVoronoiCells: Bool = true
    }

    @State
    var points: [CGPoint] = [
        CGPoint(x: 0.51, y: 0.5),
        CGPoint(x: 0.8, y: 0.6),
        CGPoint(x: 0.8, y: 0.4),
        CGPoint(x: 0.2, y: 0.4),
        CGPoint(x: 0.2, y: 0.6),
        CGPoint(x: 0.62, y:0.86),
        CGPoint(x: 0.80, y:0.65),
        CGPoint(x: 0.85, y:0.45),
        CGPoint(x: 0.68, y:0.28),
        CGPoint(x: 0.50, y:0.20),
        CGPoint(x: 0.30, y:0.30),
        CGPoint(x: 0.22, y:0.50),
        CGPoint(x: 0.32, y:0.68),
        CGPoint(x: 0.48, y:0.74),
        CGPoint(x: 0.66, y:0.68)
    ]

    @State
    var triangles: [Triangle] = []

    @State
    var convexHull: [CGPoint] = []

    @State
    var voronoiEdges: [VoronoiEdge] = []

    @State
    var size: CGSize = .zero

    @State
    var zoom = 1.0

    @State
    var gestureZoom = 1.0

    @State
    var startingZoom: CGFloat?

    @State
    var options: Options = Options()

    var body: some View {
        let scale = min(size.width, size.height) * zoom * gestureZoom
        ZStack {
            Canvas { context, size in
                render(context: context, size: size, scale: scale)
            }
            ForEach(Array(points.enumerated()), id: \.0) { index, point in
                SwiftUI.Circle().frame(width: 10, height: 10)
                    .foregroundColor(.black)
                    .position(x: point.x * scale, y: point.y * scale)
                    .gesture(DragGesture()
                        .onChanged { value in
                            points[index] = CGPoint(
                                x: value.location.x / scale,
                                y: value.location.y / scale
                            )
                        }
                    )
                    .contextMenu {
                        Button("Delete") {
                            points.remove(at: index)
                        }
                        Button("Log") {
                            print("Point \(index): \(point)")
                            print("Triangles (hasVertex): \(triangles.filter { $0.hasVertex(point) })")
                            print("Triangles (contains): \(triangles.filter { $0.contains(point) })")
                            print("On convex hull: \(convexHull.contains(point))")
                            print("Voronoi edges: \(voronoiEdges.filter { $0.leftSite == point || $0.rightSite == point })")
                        }
                    }
            }
        }
        .onChange(of: points, initial: true) {
            triangles = delauneyTriangulationBowyerWatson(points)
            convexHull = convexHullGrahamScan(points: points)
            voronoiEdges = computeVoronoiEdges(from: triangles)
        }
        .gesture(MagnifyGesture().onChanged { value in
            gestureZoom = max(value.magnification, 0.01)
        }
            .onEnded { _ in
                zoom = gestureZoom
                gestureZoom = 1.0

            })
        .onGeometryChange(for: CGSize.self, of: \.size, action: { size = $0 })
        .toolbar {
            Button("Random Points") {
                generateRandomPoints()
            }
            ShareLink(item: points, preview: SharePreview("Points"))
            CopyButton(item: points)
        }
        .overlay(alignment: .bottomTrailing) {
            Form {
                Toggle("Draw Convex Hull", isOn: $options.drawConvexHull)
                Toggle("Draw Triangulation", isOn: $options.drawTriangulation)
                Toggle("Draw Circumcircles", isOn: $options.drawCircumcircles)
                Toggle("Draw Voronoi", isOn: $options.drawVoronoi)
                Toggle("Draw Voronoi Cells", isOn: $options.drawVoronoiCells)
            }
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .padding()
        }
        .inspector(isPresented: .constant(true)) {
            inspector()
                .inspectorColumnWidth(min: 200, ideal: 200, max: 30000)
        }
    }

    func generateRandomPoints() {
        // Generate between 10 and 20 random points
        let count = Int.random(in: 10...20)
        let newPoints = (0..<count).map { _ in
            CGPoint(
                x: CGFloat.random(in: 0.1...0.9),
                y: CGFloat.random(in: 0.1...0.9)
            )
        }
        points.append(contentsOf: newPoints)
    }

    @ViewBuilder
    func inspector() -> some View {
        VStack {
            Text("Points: \(points.count)")
            Text("Triangles: \(triangles.count)")
            Text("Convex Hull: \(convexHull.count)")
            Text("Voronoi Edges: \(voronoiEdges.count)")

            TabView {
                Table(points.identifiedByIndex()) {
                    TableColumn("ID") { Text("\($0.id)") }
                    TableColumn("X") { Text("\($0.value.x)") }
                    TableColumn("Y") { Text("\($0.value.y)") }
                }
                .tabItem {
                    Label("Points", systemImage: "circle")
                }
                Table(triangles.identifiedByIndex()) {
                    TableColumn("ID") { Text("\($0.id)") }
                    TableColumn("A") { Text("\($0.value.a)") }
                    TableColumn("B") { Text("\($0.value.b)") }
                    TableColumn("C") { Text("\($0.value.c)") }
                }
                .tabItem {
                    Label("Triangles", systemImage: "triangle")
                }
                Table(voronoiEdges.identifiedByIndex()) {
                    TableColumn("ID") { Text("\($0.id)") }
                        .width(50)
                    TableColumn("Left") { Text("\($0.value.leftSite)") }
                        .width(100)
                    TableColumn("Right") { Text("\($0.value.rightSite.map({ "\($0)" }) ?? "<nil>")") }
                        .width(100)
                    TableColumn("Kind") { Text("\($0.value.kind)") }
                }
                .tabItem {
                    Label("Voronoi Edges", systemImage: "triangle")
                }
            }
        }

    }

    func render(context: GraphicsContext, size: CGSize, scale: CGFloat) {
        let transform = CGAffineTransform(scaleX: scale, y: scale)

        if options.drawVoronoiCells {
            let polygons = computeInteriorVoronoiCells(points: points, edges: voronoiEdges, triangles: triangles)
            for (point, polygon) in polygons {
                guard let polygon else {
                    continue
                }
                context.fill(Path(polygon).applying(transform), with: .color(Color(forHashable: point).opacity(0.2)))
            }
        }

//                context.stroke(
//                    Path(superTriangle).applying(transform),
//                    with: .color(.purple),
//                    lineWidth: 1
//                )
//
        if options.drawConvexHull {
            context.stroke(
                Path { path in
                    path.addLines(convexHull)
                    path.closeSubpath()
                }.applying(transform),
                with: .color(.red)
            )
        }

        // Draw triangulation
        for triangle in triangles {
            if options.drawTriangulation {
                context.stroke(
                    Path(triangle).applying(transform),
                    with: .color(.cyan),
                    lineWidth: 1
                )
            }

            if options.drawCircumcircles {
                // Draw circumcircles for debugging
                let circle = triangle.circumcircle!
                let circleRect = CGRect(
                    x: circle.center.x - circle.radius,
                    y: circle.center.y - circle.radius,
                    width: circle.radius * 2,
                    height: circle.radius * 2
                )
                context.stroke(
                    Path(ellipseIn: circleRect).applying(transform),
                    with: .color(.green),
                    lineWidth: 0.5
                )
            }
        }

        // Draw voronoi
        if options.drawVoronoi {
            for edge in voronoiEdges {
                context.stroke(Path(edge, maxRayLength: 1000).applying(transform), with: .color(.blue), lineWidth: 1.0)
            }
        }
    }
}

extension Path {
    init(_ edge: VoronoiEdge, maxRayLength: CGFloat = 1000) {
        self = Path { path in
            switch edge.kind {
            case .segment(let segment):
                path = Path(segment)
            case .ray(let ray):
                path = Path(LineSegment(ray: ray, maxLength: maxRayLength))
            }
        }
    }
}

extension Color {
    init(forHashable hashable: some Hashable) {

        var hash = Hasher()
        hashable.hash(into: &hash)
        let value = hash.finalize()
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

