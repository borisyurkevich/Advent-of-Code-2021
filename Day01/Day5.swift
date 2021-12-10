enum Day5 {

    static func run() {
        let input = readFile("day5.txt")

        let lineSegments = input.lines.compactMap(LineSegment.parse)


        let maxWidth = lineSegments.flatMap( {[$0.start, $0.end]})
            .map(\.x)
            .max() ?? 1

        let maxHeight = lineSegments.flatMap( {[$0.start, $0.end]})
            .map(\.y)
            .max() ?? 1

        var floor = OceanMap(width: maxWidth + 1, height: maxHeight + 1)
        for segment in lineSegments {
            print(segment.debugDescription)
            floor.addHydrothermalVentLine(segment)
        }
        print(floor.debugDescription)

        print("At least 2 lines overlap: ")
        let count = floor.overlapCount(minOverlaps: 2)
        print("\(count)")
    }
}

struct Coordinate: Hashable, Equatable {
    let x: Int
    let y: Int

    static func parse(_ string: String) -> Coordinate? {
        let parts = string
            .trimmingCharacters(in: .whitespaces)
            .split(separator: ",")
            .compactMap(Int.init)

        guard parts.count == 2 else {
            return nil
        }

        return Coordinate(x: parts[0], y: parts[1])
    }

    var debugDescription: String {
        "\(x),\(y)"
    }
}

struct LineSegment {
    let start: Coordinate
    let end: Coordinate

    static func parse(_ line: String) -> LineSegment? {
        let coordinates = line.split(separator: ">")
            .map {
                String($0)
                    .trimmingCharacters(in: .whitespaces)
                    .replacingOccurrences(of: "-", with: "")
            }
            .compactMap(Coordinate.parse)
        guard coordinates.count == 2 else { return nil }
        return .init(start: coordinates[0], end: coordinates[1])
    }

    var debugDescription: String {
        "\(start.debugDescription) -> \(end.debugDescription)"
    }

    var coordinates: [Coordinate] {
        // assume no diagonals

        guard start.x == end.x || start.y == end.y else {
            return []
        }

        let minX = min(start.x, end.x)
        let maxX = max(start.x, end.x)
        let minY = min(start.y, end.y)
        let maxY = max(start.y, end.y)

        return (minX...maxX).flatMap { x in
            (minY...maxY).map { y in
                Coordinate(x: x, y: y)
            }
        }
    }
}

struct OceanMap {
    internal init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    let width: Int
    let height: Int

    private var hydrothermalVentCoordinates: [Coordinate: Int] = [:]

    mutating func addHydrothermalVentLine(_ line: LineSegment) {
        line.coordinates.forEach { coord in
            hydrothermalVentCoordinates[coord, default: 0] += 1
        }
    }

    func overlapCount(minOverlaps: Int) -> Int {
        hydrothermalVentCoordinates.filter { (key, value) in
            value >= minOverlaps
        }.count
    }

    var debugDescription: String {
//        print("Vent coords: \(hydrothermalVentCoordinates)")
        var output = ""
        for y in 0..<height {
            for x in 0..<width {
                let coord = Coordinate(x: x, y: y)
                let mark = hydrothermalVentCoordinates[coord].flatMap(String.init) ?? "."
                output += mark
            }
            output += "\n"
        }
        return output
    }
}
