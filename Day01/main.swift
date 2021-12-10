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

func readFile(_ name: String) -> String {
    // #file gives you current file path
    let projectURL = URL(fileURLWithPath: #file).deletingLastPathComponent()
    let fileURL = projectURL.appendingPathComponent(name)
    let data = try! Data(contentsOf: fileURL)
    return String(data: data, encoding: .utf8)!
}

extension String {

    var lines: [String] {
        split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
    }
}

enum Day1 {
    static func run() {
        let input = readFile("day1-p2.test")
        let scanner = DepthScanner.parse(input)
        let count = scanner.increaseCount(windowSize: 3)
        print("Depth incrases \(count) times")
    }
}

enum Day2 {
    static func run() {
        let input = readFile("day2.test")
        let movements = input.lines.compactMap(Movement.parse)
        let tracker = PositionTracker()
        movements.forEach {
            tracker.process($0)
        }

        print("position is now \(tracker.position)")
        print("Aim is now \(tracker.aim)")
        print("Day 2 answer: \(tracker.depths * tracker.position)")
    }
}

enum Day3 {
    static func run() {
        let lines = readFile("day3.test").lines
        let reading = lines.map(Reading.init)
        let diagnostics = Diagnostics(readings: reading)
        print("Gamma Rate: \(diagnostics.gammaRate)")
        print("Epsilon Rate: \(diagnostics.epsilonRate)")
        print("Consumption: \(diagnostics.powerConsumption)")
    }
}

class Diagnostics {

    let readings: [Reading]

    init(readings: [Reading]) {
        self.readings = readings
    }

    var powerConsumption: UInt {
        gammaRate * epsilonRate
    }

    var gammaRate: UInt {
        guard !readings.isEmpty else { return 0 }
        var num: UInt = 0
        let width = readings[0].width
        for i in 0 ..< width {
            let bit = commonBit(at: i)
            num += bit << ((width - 1) - i)
        }
        return num
    }

    var epsilonRate: UInt {
        let bits = (0..<readingWidth).map { i in
            leastCommonBit(at: i)
        }
        return constuctInt(bits: bits)
    }

    private func constuctInt(bits: [UInt]) -> UInt {
        guard !bits.isEmpty else { return 0 }
        return bits.enumerated().reduce(0) { (num: UInt, item: (index: Int, bit: UInt)) -> UInt in
            num + item.bit << ((bits.count - 1) - item.index)
        }
    }

    private lazy var readingWidth: Int = {
        readings.map(\.width).max() ?? 0
    }()

    private func commonBit(at position: Int) -> UInt {
        let bits = readings.map { $0.bit(at: position) }
        let sum = bits.reduce(0, +)
        return UInt((Float(sum) / Float(readings.count)).rounded())
    }

    private func leastCommonBit(at position: Int) -> UInt {
        1 - commonBit(at: position)
    }
}

struct Reading {
    private let value: UInt
    let width: Int

    init(stringValue: String) {
        value = UInt(stringValue, radix: 2)!
        width = stringValue.count
    }

    func bit(at position: Int) -> UInt {
        let shiftAmount = (width - 1) - position
        return (value & (0b1 << shiftAmount)) >> shiftAmount
    }
}

class PositionTracker {
    private(set) var aim = 0
    private(set) var position = 0
    private(set) var depths = 0

    init() {

    }

    func process(_ mov: Movement) {
        print("processing \(mov)")
        switch mov {
        case .down(let x): aim += x
        case .up(let x): aim -= x
        case .forawrd(let x):
            position += x
            depths += (aim * x)
        }

    }
}

enum Movement {

    case forawrd(Int)
    case up(Int)
    case down(Int)


    static func parse(_ input: String) -> Self? {
        let parts = input.split(separator: " ")
        guard parts.count == 2 else {
            return nil
        }
        guard let amount = Int(parts[1]) else {
            return nil
        }
        switch parts[0] {
        case "forward": return .forawrd(amount)
        case "up": return .up(amount)
        case "down": return .down(amount)
        default: return nil
        }
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

Day3.run()
