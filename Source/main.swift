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

extension Int {
    init?(_ s: Substring) {
        if let int = Int(String(s)) {
            self = int
        } else {
            return nil
        }
    }
}

Day8.run()
