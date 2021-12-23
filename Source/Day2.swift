//
//  Day2.swift
//  AdventOfCode
//
//  Created by Boris Yurkevich on 23/12/2021.
//

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

}
