//
//  Day3.swift
//  AdventOfCode
//
//  Created by Boris Yurkevich on 23/12/2021.
//

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


}
