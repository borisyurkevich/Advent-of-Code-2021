//
//  Day6.swift
//  Day01
//
//  Created by Boris Yurkevich on 14/12/2021.
//

import Foundation

enum Day6 {
    static func run() {
        let file = readFile("day6.txt")

        let fish = file.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap(Int.init)
            .map(LanternFish.init)

        let sim = LanternFishSimulator(fish: fish)
        sim.runSimulation(days: 256)
        print("total fish \(sim.fishCount)")
    }
}

final class LanternFishSimulator {
    typealias Age = Int
    typealias FishCount = Int
    private(set) var fishByAge: [Age: FishCount] = [:]

    internal init(fish: [LanternFish] = []) {
        self.fishByAge = Dictionary(grouping: fish, by: { $0.age })
            .mapValues { $0.count }
    }

    func runSimulation(days: Int) {
        for _ in 1...days {
            var spawnCount = 0
            fishByAge.keys.sorted().forEach { age in
                let fishAtThisAge = fishByAge[age] ?? 0
                fishByAge[age] = 0

                if age == 0 {
                    spawnCount += fishAtThisAge
                } else {
                    fishByAge[age - 1, default: 0] += fishAtThisAge
                }
            }

            let newParentAge = 6
            let newChildAge = 8
            fishByAge[newParentAge, default: 0] += spawnCount
            fishByAge[newChildAge, default: 0] += spawnCount
        }
    }

    var fishCount: Int {
        fishByAge.values.reduce(0, +)
    }

    private var fishString: String {
        fishByAge.keys.sorted().map { age in
            "\(age) : \(fishByAge[age] ?? 0)"
        }.joined(separator: ", ") + " ==> \(fishCount)"
    }
}

struct LanternFish: CustomStringConvertible {

    private(set) var age: Int

    init(age: Int) {
        self.age = age
    }

    mutating func tick() -> LanternFish? {
        if age == 0 {
            // spawn
            age = 6
            return LanternFish(age: 8)
        } else {
            age -= 1
            return nil
        }
    }

    var description: String {
        "\(age)"
    }
}
