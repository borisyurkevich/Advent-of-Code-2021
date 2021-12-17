//
//  main.swift
//  Day01
//
//  Answer part 1: 1448, part 2: 1471
//
//  Created by Boris Yurkevich on 07/12/2021.
//

import Foundation
//import Algorithms
import CloudKit

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

        print("02 generator raing \(diagnostics.o2rating)")
        print("Co2 scurbber rating \(diagnostics.co2rating)")
        print("Live support \(diagnostics.liveSupport)")
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

    var liveSupport: UInt {
        o2rating * co2rating
    }

    var gammaRate: UInt {
        guard !readings.isEmpty else { return 0 }
        var num: UInt = 0
        let width = readings[0].width
        for i in 0 ..< width {
            let bit = commonBit(at: i, in: readings)
            num += bit << ((width - 1) - i)
        }
        return num
    }

    var epsilonRate: UInt {
        let bits = (0..<readingWidth).map { i in
            leastCommonBit(at: i, in: readings)
        }
        return constuctInt(bits: bits)
    }

    var o2rating: UInt {
        filterReadings { i, readings in
            let common = commonBit(at: i, in: readings)
            return readings.filter { r in
                r.bit(at: i) == common
            }
        }?.value ?? 0
    }

    var co2rating: UInt {
        filterReadings { i, readings in
            let leastCommon = leastCommonBit(at: i, in: readings)
            return readings.filter { r in
                r.bit(at: i) == leastCommon
            }
        }?.value ?? 0
    }

    private func constuctInt(bits: [UInt]) -> UInt {
        guard !bits.isEmpty else { return 0 }
        return bits.enumerated().reduce(0) { (num: UInt, item: (index: Int, bit: UInt)) -> UInt in
            num + item.bit << ((bits.count - 1) - item.index)
        }
    }

    private func filterReadings(using filterBlock: (Int, [Reading]) -> [Reading]) -> Reading? {
        var filteredReadings = self.readings

        for i in 0..<readingWidth {
            filteredReadings = filterBlock(i, filteredReadings)

            if filteredReadings.count == 1 {
                return filteredReadings[0]
            }
        }

        return nil
    }

    private lazy var readingWidth: Int = {
        readings.map(\.width).max() ?? 0
    }()

    private func commonBit(at position: Int, in readings: [Reading]) -> UInt {
        let bits = readings.map { $0.bit(at: position) }
        let sum = bits.reduce(0, +)
        return UInt((Float(sum) / Float(readings.count)).rounded())
    }

    private func leastCommonBit(at position: Int, in readings: [Reading]) -> UInt {
        1 - commonBit(at: position, in: readings)
    }
}

struct Reading {
    let value: UInt
    let width: Int
    let stringValue: String

    init(stringValue: String) {
        value = UInt(stringValue, radix: 2)!
        width = stringValue.count
        self.stringValue = stringValue
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
        0
//
//        assert(windowSize > 0)
//        var windowSums: [Int] = []
//        for index in depths.indices {
//            if index < windowSize - 1 {
//                continue
//            }
//            var sum = 0
//            for i in 0..<windowSize {
//                sum += depths[index - i]
//            }
//            windowSums.append(sum)
//
//        }
//
//        for pair in windowSums.adjacentPairs() {
//            let diff = pair.1 - pair.0
//            print("[\(pair.0) -> \(pair.1)] \(diff)")
//        }
//        return windowSums.adjacentPairs()
//            .map { $1 - $0}
//            .filter { $0 > 0 }
//            .count
    }

    static func parse(_ input: String) -> Self {
        let depths = input.split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .compactMap { Int(String($0)) }
        return .init(depth: depths)
    }
}

enum Day4 {
    static func run() {
        let input = readFile("day4.test")
        var game = BingoGameParser.parse(input)

        print("Numbers:", game.numbers)
        for board in game.boards {
            print(board.debugDescription)
        }

        game.run()
    }


    struct BingoCell {
        let value: Int
        let isMarked: Bool

        init(_ value: Int, isMarked: Bool = false) {
            self.value = value
            self.isMarked = isMarked
        }

        func marked() -> Self {
            .init(value, isMarked: true)
        }

        var debugDescription: String {
            "\(String(format: "%02d", value))\(isMarked ? "*" : " ")"
        }
    }

    struct BingoBoard {
        let cells: [BingoCell]
        let size: Int

        var isFinished: Bool = false

        init(numbers: [Int], boardSize: Int) {
            cells = numbers.map { BingoCell($0) }
            assert(cells.count == boardSize * boardSize)
            size = boardSize
        }

        private init(cells: [BingoCell], size: Int) {
            self.cells = cells
            self.size = size
        }

        func evaluating(_ number: Int) -> Self {
            .init(cells: cells.map { c in
                BingoCell(c.value, isMarked: c.value == number || c.isMarked)
            }, size: size)
        }

        var isWinning: Bool {
            // rows
            for row in 0..<size {
                if (0..<size).map({ cells[index(row, $0)] }).allSatisfy(\.isMarked) {
                    return true
                }
            }

            // columns
            for col in 0..<size {
                if (0..<size).map({ cells[index($0, col)] }).allSatisfy(\.isMarked) {
                    return true
                }
            }

            return false
        }

        var debugDescription: String {
            var s = ""
            for row in 0..<size {
                for col in 0..<size {
                    let i = index(row, col)
                    s += cells[i].debugDescription
                    s += " "
                }
                s += "\n"
            }
            s += "\n"
            return s
        }

        private func index(_ row: Int, _ col: Int) -> Int {
            let validRange = 0..<size
            assert(validRange ~= row && validRange ~= col)
            return row * size + col
        }
    }

    struct BingoGame {
        let numbers: [Int]
        var boards: [BingoBoard]

        struct WinInfo {
            let board: BingoBoard
            let winNumber: Int
        }

        mutating func run() {
            var wins: [WinInfo] = []

            for number in numbers {
                print("We drew the number: \(number)")

                for (index, board) in boards.enumerated() {
                    if board.isFinished {
                        continue
                    }
                    var newBoard = board.evaluating(number)
                    boards[index] = newBoard

                    print(newBoard.debugDescription)
                    if newBoard.isWinning {
                        newBoard.isFinished = true
                        wins.append(.init(board: newBoard, winNumber: number))
                    }
                    boards[index] = newBoard
                    print(newBoard.debugDescription)
                }
            }

            if let lastWin = wins.last {
                let sum = lastWin.board.cells
                    .filter { !$0.isMarked }
                    .map(\.value)
                    .reduce(0, +)
                print("unmarked sum: \(sum)")
                print("solution \(sum * lastWin.winNumber)")
            }
        }
    }

    struct BingoGameParser {
        static func parse(_ input: String) -> BingoGame {
            var lines = input.lines

            let numbers = lines.removeFirst().split(separator: ",").compactMap(Int.init)
            let boardSize = 5
            var boards = [BingoBoard]()

            var boardLines = [String]()
            for line in lines {
                if line.isEmpty {
                    continue
                }
                boardLines.append(line)
                if boardLines.count == boardSize {
                    let boardNumbers = boardLines.flatMap {
                        $0.split(separator: " ").compactMap(Int.init)
                    }
                    let board = BingoBoard(numbers: boardNumbers, boardSize: boardSize)
                    boards.append(board)
                    boardLines = []
                }
            }

            return BingoGame(numbers: numbers, boards: boards)
        }
    }
}


//Day6.run()
Day7.run()


extension Int {
    init?(_ s: Substring) {
        if let int = Int(String(s)) {
            self = int
        } else {
            return nil
        }
    }
}
