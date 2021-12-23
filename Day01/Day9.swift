//
//  Day9.swift
//  Day01
//
//  Created by Boris Yurkevich on 17/12/2021.
//

import Foundation

enum Day9 {

    static func run() {
        let input = readFile("day9.txt")
        let values = input.lines.map { line in
            line.compactMap() {
                Int(String($0))
            }
        }
        let map = HeightMap(values: values)
        let risks = map.lowPointRisks()
        print(risks)
        let sum = risks.reduce(0, +)
        print("Sum of low points: \(sum)")
    }
}

struct HeightMap {
    let values: [[Int]]

    struct Coordinate: Hashable {
        let row: Int
        let col: Int
    }

    func lowPoints() -> [Int] {
        var lowPoints: [Int] = []
        var knownHighPointIndices: Set<HeightMap.Coordinate> = []

        for row in 0..<values.count {
            for col in 0..<values[row].count {
                let coord = HeightMap.Coordinate(row: row, col: col)
                if knownHighPointIndices.contains(coord) {
                    continue
                }
                let neighbors = neighbors(for: coord)
                let neigborHeights = neighbors.map {
                    (coord: $0, height: height(at: $0))
                }
                let thisHeight = height(at: coord)
                if neigborHeights.allSatisfy({ $0.height > thisHeight }) {
                    lowPoints.append(thisHeight)
                    knownHighPointIndices.formUnion(neighbors)
                }

            }
        }
        return lowPoints
    }

    func lowPointRisks() -> [Int] {
        lowPoints().map { $0 + 1 }
    }

    func height(at coordinate: Coordinate) -> Int {
        values[coordinate.row][coordinate.col]
    }

    func neighbors(for c: HeightMap.Coordinate) -> Set<HeightMap.Coordinate> {
        guard !values.isEmpty else { return [] }

        var neighbors: Set<HeightMap.Coordinate> = []
        if c.row > 0 {
            neighbors.insert(.init(row: c.row - 1, col: c.col))
        }
        if c.col > 0 {
            neighbors.insert(.init(row: c.row, col: c.col - 1))
        }
        if c.row < values.count - 1 {
            neighbors.insert(.init(row: c.row + 1, col: c.col))
        }
        if c.col < values[0].count - 1 {
            neighbors.insert(.init(row: c.row, col: c.col + 1))
        }
        return neighbors
    }
}
