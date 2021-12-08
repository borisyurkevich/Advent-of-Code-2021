//
//  main.swift
//  Day01
//
//  Answer part 1: 1448, part 2: 1471
//
//  Created by Boris Yurkevich on 07/12/2021.
//

import Foundation
import Algorithms

print("Day 1:")

func readFile(_ name: String) -> String {
    // #file gives you current file path
    let projectURL = URL(fileURLWithPath: #file).deletingLastPathComponent()
    let fileURL = projectURL.appendingPathComponent(name)
    let data = try! Data(contentsOf: fileURL)
    return String(data: data, encoding: .utf8)!
}

enum Day1 {
    static func run() {
        let input = readFile("day1-p2.test")
        let scanner = DepthScanner.parse(input)
        let count = scanner.increaseCount(windowSize: 3)
        print("Depth incrases \(count) times")
    }
}

struct DepthScanner {
    let depths: [Int]
    init(depth: [Int]) {
        self.depths = depth
    }

    func increaseCount(windowSize: Int = 1) -> Int {

        assert(windowSize > 0)
        var windowSums: [Int] = []
        for index in depths.indices {
            if index < windowSize - 1 {
                continue
            }
            var sum = 0
            for i in 0..<windowSize {
                sum += depths[index - i]
            }
            windowSums.append(sum)

        }

        for pair in windowSums.adjacentPairs() {
            let diff = pair.1 - pair.0
            print("[\(pair.0) -> \(pair.1)] \(diff)")
        }
        return windowSums.adjacentPairs()
            .map { $1 - $0}
            .filter { $0 > 0 }
            .count
    }

    static func parse(_ input: String) -> Self {
        let depths = input.split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .compactMap { Int(String($0)) }
        return .init(depth: depths)
    }
}

Day1.run()
