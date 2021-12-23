//
//  Day8.swift
//  Day01
//
//  Created by Boris Yurkevich on 23/12/2021.
//

import Foundation

enum Day8 {

    static func run() {
        let file = readFile("Day8.txt")
        let displays = file.lines.map(Display.init)

        print("displays: \(displays)")

        let count = displays
            .flatMap(\.outputDigits)
            .filter { d in
                is1(d) || is4(d) || is7(d) || is8(d)
            }
            .count

        print(count)
    }

    static func is1(_ segments: String) -> Bool {
        segments.count == 2
    }

    static func is4(_ segments: String) -> Bool {
        segments.count == 4
    }

    static func is7(_ segments: String) -> Bool {
        segments.count == 3
    }

    static func is8(_ segments: String) -> Bool {
        segments.count == 7
    }
}

struct Display {
    let patterns: [String]
    let outputDigits: [String]

    init(_ input: String) {
        let parts = input.split(separator: "|")
        assert(parts.count == 2)
        patterns = parts.first!.split(separator: " ").map(String.init)
        outputDigits = parts[1].split(separator: " ").map(String.init)
    }
}
