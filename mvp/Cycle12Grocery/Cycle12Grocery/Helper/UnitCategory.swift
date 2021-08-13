//
//  UnitCategory.swift
//  Habitify Watch App Extension
//
//  Created by Peter Vu on 7/27/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Foundation

public enum UnitCategory: String, Codable, Equatable, Hashable, CaseIterable {
    case scalar
    case length
    case volume
    case mass
    case duration
    case energy

    var units: [UnitType] {
        switch self {
        case .scalar:
            return [.count, .step]

        case .duration:
            return [.seconds, .minutes, .hours]

        case .length:
            return [.kilometers, .meters, .feet, .yard, .miles]

        case .mass:
            return [.kilograms, .grams, .milligrams, .ounces, .pounds, .micrograms]

        case .energy:
            return [.kilojoules, .calories, .kilocalories, .joules]

        case .volume:
            return [.liters, .milliliters, .fluidOunces, .cups]
        }
    }

    var baseUnit: UnitType {
        switch self {
        case .scalar:
            return .count

        case .duration:
            return .seconds

        case .length:
            return .meters

        case .mass:
            return .kilograms

        case .energy:
            return .joules

        case .volume:
            return .liters
        }
    }
}

final class ScalarUnit: Dimension {
    override var converter: UnitConverter {
        return UnitConverterLinear(coefficient: 1)
    }

    class func count() -> ScalarUnit {
        return ScalarUnit(symbol: "rep", converter: UnitConverterLinear(coefficient: 1))
    }

    class func step() -> Dimension {
        return ScalarUnit(symbol: "step", converter: UnitConverterLinear(coefficient: 1))
    }

    override class func baseUnit() -> ScalarUnit {
        return Self.count()
    }
}

extension UnitType {
    private static let unitCategoryTable: [UnitType: UnitCategory] = {
        var table: [UnitType: UnitCategory] = [:]
        for category in UnitCategory.allCases {
            for unit in category.units {
                table[unit] = category
            }
        }
        return table
    }()

    var category: UnitCategory? { Self.unitCategoryTable[self] }

    func toFoundationUnit() -> Dimension {
        switch self {
        case .count:
            return ScalarUnit.count()

        case .step:
            return ScalarUnit.step()

        case .kilometers:
            return UnitLength.kilometers

        case .meters:
            return UnitLength.meters

        case .feet:
            return UnitLength.feet

        case .yard:
            return UnitLength.yards

        case .miles:
            return UnitLength.miles

        case .liters:
            return UnitVolume.liters

        case .milliliters:
            return UnitVolume.milliliters

        case .fluidOunces:
            return UnitVolume.fluidOunces

        case .cups:
            return UnitVolume.cups

        case .kilograms:
            return UnitMass.kilograms

        case .grams:
            return UnitMass.grams

        case .milligrams:
            return UnitMass.milligrams

        case .ounces:
            return UnitMass.ounces

        case .pounds:
            return UnitMass.pounds

        case .hours:
            return UnitDuration.hours

        case .minutes:
            return UnitDuration.minutes

        case .seconds:
            return UnitDuration.seconds

        case .kilojoules:
            return UnitEnergy.kilojoules

        case .joules:
            return UnitEnergy.joules

        case .kilocalories:
            return UnitEnergy.kilocalories

        case .calories:
            return UnitEnergy.calories

        case .micrograms:
            return UnitMass.micrograms
        }
    }
}
