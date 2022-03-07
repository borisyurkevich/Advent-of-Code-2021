//
//  Day9.swift
//  Day01
//
//  Created by Boris Yurkevich on 17/12/2021.
//

import Foundation
import CloudKit

enum Day10 {

    static func run() {

        let input = readFile("day10.txt")
        var processor = LineProcess()

        for line in input.lines {
            processor.process(line)
        }
        print("incomplete lines: \(processor.incompleteLines.count)")
        for incopmpleteLine in processor.incompleteLines {
            let reversed: [Character] = incopmpleteLine.reversed()
            let chars = processor.findIncompleteCharacters(incompleteLine: reversed)
            processor.scores.addAutocompleteScore(incompleCharacters: chars)
        }
        print(processor.scores.autompleteScore)
        print("answer: \(processor.scores.findPart2Answer())")
    }
}
struct LineProcess {

    var chunks = [String]() // Each chunk must start and end with a character
    var scores = ScoreBoard()
    var incompleteLines = [[Character]]()

    mutating func process(_ line: String) {
        var opens = [Character]()
        var isCorupted = false

        for character in line {
            if isOpenining(char: character) {
                opens.append(character)
            } else {
                guard let lastCharacter = opens.last else {
                    fatalError("Unexpected data")
                }
                if closingCharacter(char: character, lastFromOpens: lastCharacter) {
                    // Remove
                    _ = opens.popLast()
                } else {
                    _ = opens.popLast()
                    scores.addIllegalCharacter(character)
                    isCorupted = true
                }
            }
        }

        // Collect incomplete lines only
        if !opens.isEmpty && !isCorupted {
            incompleteLines.append(opens)
        }
    }

    func findIncompleteCharacters(incompleteLine: [Character]) -> [Character] {
        var result = [Character]()
        for char in incompleteLine {
            result.append(closingCharacter(char: char))
        }
        return result
    }

    func isOpenining(char: Character) -> Bool {
        assert(char != " ")
        if char == "{" || char == "<" || char == "[" || char == "(" {
            return true
        } else {
            return false
        }
    }

    func closingCharacter(char: Character, lastFromOpens: Character) -> Bool {
        assert(!isOpenining(char: char))
        assert(isOpenining(char: lastFromOpens))
        if lastFromOpens == "(" {
            return char == ")"
        } else if lastFromOpens == "{" {
            return char == "}"
        } else if lastFromOpens == "[" {
            return char == "]"
        } else if lastFromOpens == "<" {
            return char == ">"
        }
        fatalError("unexpected input")
    }

    func closingCharacter(char: Character) -> Character {
        assert(isOpenining(char: char))
        if char == "(" {
            return ")"
        } else if char == "{" {
            return "}"
        } else if char == "[" {
            return "]"
        } else if char == "<" {
            return ">"
        }
        fatalError("unexpected input")
    }
}

struct ScoreBoard {

    var points = 0
    var autompleteScore = [Int]()

    mutating func addIllegalCharacter(_ char: Character) {
        guard let score = pointsTable[char] else {
            fatalError()
        }
        points -= score
    }

    mutating func addAutocompleteScore(incompleCharacters: [Character]) {
        var result = 0
        for char in incompleCharacters {
            guard let score = autoCompleteTable[char] else {
                fatalError()
            }
            result *= 5
            result += score
        }
        autompleteScore.append(result)
    }

    private let pointsTable: [Character : Int] = [
        ")" : 3,
        "]" : 57,
        "}" : 1197,
        ">" : 25137
    ]

    // Part 2
    private let autoCompleteTable: [Character : Int] = [
        ")" : 1,
        "]" : 2,
        "}" : 3,
        ">" : 4
    ]

    func findPart2Answer() -> Int {
        let sorted = autompleteScore.sorted()
        let index = (sorted.count - 1) / 2
        return sorted[Int(index)]
    }
}
