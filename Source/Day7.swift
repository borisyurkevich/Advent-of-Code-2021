//
//  Day7.swift
//  Day01
//
//  Created by Boris Yurkevich on 17/12/2021.
//

import Foundation

enum Day7 {

    static func run() {
        let input = readFile("Day7.txt")
        let positions = input.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap (Int.init)

        let aligner = HorizontalAligner(positions: positions)
        let (pos, cost) = aligner.minCostToAlign()

        print("al at \(pos)")
        print("min cost is: \(cost)")
    }
}

struct HorizontalAligner {

    let positions: [Int]

    init(positions: [Int]) {
        self.positions = positions
    }

    func costToMove(to target: Int) -> Int {
        let costs = positions.map { pos -> Int in
            guard pos != target else { return 0}
            let distance = abs(target - pos)
            let cost = (0...distance).reduce(0, +)
            return cost
        }

        for (p, cost) in zip(positions, costs) {
            print("[\(p)] -> \(target) cost \(cost)")
        }
        return costs.reduce(0, +)
    }

    func minCostToAlign() -> (pos: Int, cost: Int) {
        guard let minPos = positions.min(),
              let maxPos = positions.max() else {
                  return (0, 0)
              }

        var pos = 0
        var minCost =  Int.max
        (minPos...maxPos).forEach { p in
            let cost = costToMove(to: p)
            if cost < minCost {
                minCost = cost
                pos = p
            }
        }
        return (pos, minCost)
    }
}

struct CrabSubmarine {

}
