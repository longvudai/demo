//
//  UnitType.swift
//  Habitify Watch App Extension
//
//  Created by Peter Vu on 7/27/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Foundation

public enum UnitType: String, Codable, Equatable, Hashable, CaseIterable {
    // Scalar
    case count = "rep"
    case step = "step"

    // Length
    case kilometers = "kM"
    case meters = "m"
    case feet = "ft"
    case yard = "yd"
    case miles = "mi"

    // Volume
    case liters = "L"
    case milliliters = "mL"
    case fluidOunces = "fl oz"
    case cups = "cup"

    // Mass
    case kilograms = "kg"
    case grams = "g"
    case milligrams = "mg"
    case ounces = "oz"
    case pounds = "lb"
    case micrograms = "mcg"

    // Duration
    case minutes = "min"
    case hours = "hr"
    case seconds = "sec"

    // Energy
    case kilojoules = "kJ"
    case kilocalories = "kCal"
    case calories = "cal"
    case joules = "J"
}

extension UnitType {
    var allowsFloat: Bool {
        switch self {
        case .count, .step, .milliliters, .seconds, .minutes, .calories, .micrograms:
            return false

        default:
            return true
        }
    }

    var maximumFractionDigits: Int {
        switch self {
        case .count, .step, .milliliters, .seconds, .minutes, .calories, .micrograms, .joules:
            return 0

        case .kilometers, .fluidOunces, .cups, .grams, .milligrams, .ounces, .kilojoules, .kilocalories:
            return 1

        case .meters, .yard, .miles, .feet, .liters, .kilograms, .pounds, .hours:
            return 2
        }
    }
}


extension UnitType {
    var valueRange: CountableClosedRange<Int> {
        switch self {
        case .step:
            return valueStep...100_000

        case .calories:
            return valueStep...2_000_000

        case .count:
            return valueStep...100

        case .cups:
            return valueStep...100

        case .feet:
            return valueStep...100_000

        case .fluidOunces:
            return valueStep...1_000

        case .grams:
            return valueStep...5_000

        case .kilograms:
            return valueStep...10

        case .hours:
            return valueStep...20

        case .kilocalories:
            return valueStep...10_000

        case .kilometers:
            return valueStep...50

        case .meters:
            return valueStep...50_000

        case .yard:
            return valueStep...50_000

        case .miles:
            return valueStep...30

        case .liters:
            return valueStep...30

        case .milliliters:
            return valueStep...30_000

        case .milligrams:
            return valueStep...10_000

        case .ounces:
            return valueStep...350

        case .pounds:
            return valueStep...20

        case .minutes:
            return valueStep...1_200

        case .seconds:
            return valueStep...72_000

        case .kilojoules:
            return valueStep...42_000

        case .micrograms:
            return valueStep...5_000

        case .joules:
            return valueStep...100_000
        }
    }

    var valueStep: Int {
        switch self {
        case .calories:
            return 500

        case .count:
            return 1

        case .cups:
            return 1

        case .feet:
            return 100

        case .fluidOunces:
            return 5

        case .grams:
            return 5

        case .kilograms:
            return 1

        case .hours:
            return 1

        case .kilocalories:
            return 100

        case .kilometers:
            return 1

        case .meters:
            return 10

        case .yard:
            return 50

        case .miles:
            return 1

        case .liters:
            return 1

        case .milliliters:
            return 100

        case .milligrams:
            return 1

        case .ounces:
            return 1

        case .pounds:
            return 1

        case .minutes:
            return 1

        case .seconds:
            return 10

        case .kilojoules:
            return 50

        case .step:
            return 1_000

        case .micrograms:
            return 5

        case .joules:
            return 1_000
        }
    }
}
