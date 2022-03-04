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
            print("processing line \(line)")
            processor.process(line)
        }
        print(processor.scores.points)
    }
}
struct LineProcess {

    var chunks = [String]() // Each chunk must start and end with a character
    var scores = ScoreBoard()

    mutating func process(_ line: String) {
        var opens = [Character]()

        for character in line {
            if isOpenining(char: character) {
                opens.append(character)
            } else {
                guard let lastCharacter = opens.last else {
                    fatalError("Unexpected data")
                }
                if closingCharacter(char: character, lastFromOpens: lastCharacter) {
                    // Remove
                    _ = opens.removeLast()
                } else {
                    _ = opens.removeLast()
                    scores.addIllegalCharacter(character)
                }
            }
        }
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
}

struct ScoreBoard {

    var points = 0

    mutating func addIllegalCharacter(_ char: Character) {
        guard let score = pointsTable[char] else {
            fatalError()
        }
        points -= score
    }

    private let pointsTable: [Character : Int] = [
        ")" : 3,
        "]" : 57,
        "}" : 1197,
        ">" : 25137
    ]
}
