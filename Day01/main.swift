//
//  main.swift
//  Day01
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
        let input = readFile("day1.test")
        let scanner = DepthScanner.parse(input)
        let count = scanner.increaseCount()
        print("Depth incrases \(count) times")
    }
}

struct DepthScanner {
    let depths: [Int]
    init(depth: [Int]) {
        self.depths = depth
    }

    func increaseCount() -> Int {
        for pair in depths.adjacentPairs() {
            print("\(pair.0) -> \(pair.1)")
        }
        return depths.adjacentPairs()
            .map { $0.1 - $0.0}
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
