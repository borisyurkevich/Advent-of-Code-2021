//
//  Day8.swift
//  https://www.geeksforgeeks.org/seven-segment-displays/
//
//  Created by Boris Yurkevich on 23/12/2021.
//

import Foundation

enum Day8 {

    static func run() {
        let input = readFile("Day8.txt")

        let displays = input.lines.map(Display.init)
        let outputs = displays.map(DisplaySolver.init).map { solver in
            solver.solve()
        }
        print(outputs)

        let sum = outputs.reduce(0, +)
        print("sun is \(sum)")
//        let sum = outputs.reduce(0, +)
//        print("sun is \(sum)")
    }
}

class DisplaySolver {
    let display: Display

    var possibleMatches: [Character: [Character]] = [:]

    init(display: Display) {
        self.display = display
    }

    func solve() -> Int {
        let allSegments = "abcdefg"
        for char in allSegments {
            possibleMatches[char] = allSegments.map { $0 }
        }

        let one = display.patterns.first(where: { $0.count == 2 })!
        let seven = display.patterns.first(where: { $0.count == 3 })!
        let four = display.patterns.first(where: { $0.count == 4 })!
        let six = display.patterns.first(where: { $0.count == 6 && !$0.isStrictSuperset(of: one) })!
        let nine = display.patterns.first(where: { $0.count == 6 && $0.isStrictSuperset(of: four) })!
        let zero = display.patterns.first(where: { $0.count == 6 && $0 != nine && $0 != six })!
        let five = display.patterns.first(where: { $0.count == 5 && $0.isStrictSubset(of: six)})!
        let eight = display.patterns.first(where: { $0.count == 7 })!
        let three = display.patterns.first(where: { $0.count == 5 && $0.isStrictSubset(of: nine) && $0 != five})
        let two = display.patterns.first(where: { $0.count == 5 && $0 != three && $0 != five })!

        let lookup = [
            zero: 0,
            one: 1,
            two: 2,
            three: 3,
            four: 4,
            five: 5,
            six: 6,
            seven: 7,
            eight: 8,
            nine: 9
        ]

        let displayValue = display.outputDigits.enumerated().reduce(0, { sum, pair in
            let digit = lookup[pair.element]!
            let value = Int(pow(10.0, Double(display.outputDigits.count - 1 - pair.offset))) * digit
            return sum + value
        })

        return displayValue
    }

    private func updateMatches(for pattern: String, possibles: [Character]) {
        for char in pattern {
            let matches = possibleMatches[char]!
            if matches.count == 1 {
                return
            } else {
                var intersection = [Character]()
                for match in matches where possibles.contains(match) {
                    intersection.append(match)
                }
                possibleMatches[char] = intersection
            }
        }
    }

    func is1(_ segments: String) -> Bool {
        segments.count == 2
    }

    func is4(_ segments: String) -> Bool {
        segments.count == 4
    }

    func is7(_ segments: String) -> Bool {
        segments.count == 3
    }

    func is8(_ segments: String) -> Bool {
        segments.count == 7
    }
}

struct Display {
    let patterns: [Set<Character>]
    let outputDigits: [Set<Character>]

    init(_ input: String) {
        let parts = input.split(separator: "|")
        assert(parts.count == 2)
        patterns = parts[0].split(separator: " ").map { pattern in
            Set(Array(pattern))
        }
        outputDigits = parts[1].split(separator: " ").map { pattern in
            Set(Array(pattern))
        }
    }
}
