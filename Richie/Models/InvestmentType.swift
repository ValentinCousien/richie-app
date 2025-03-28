//
//  InvestmentType.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import Foundation

enum InvestmentType: String, Codable, CaseIterable, Hashable {
    case stocks = "Stocks"
    case scpi = "SCPI"
    case savings = "Savings"
    case lifeInsurance = "LifeInsurance"
    case realEstate = "RealEstate"
    case bonds = "Bonds"
    case custom = "Custom"

    var localizedName: String {
        switch self {
        case .stocks:
            String(localized: "investment.type.stocks")
        case .scpi:
            String(localized: "investment.type.scpi")
        case .savings:
            String(localized: "investment.type.savings")
        case .lifeInsurance:
            String(localized: "investment.type.lifeInsurance")
        case .realEstate:
            String(localized: "investment.type.realEstate")
        case .bonds:
            String(localized: "investment.type.bonds")
        case .custom:
            String(localized: "investment.type.custom")
        }
    }

    var defaultRates: (low: Double, high: Double) {
        switch self {
        case .stocks:
            return (5.0, 10.0)
        case .scpi:
            return (3.5, 5.5)
        case .savings:
            return (0.5, 2.0)
        case .lifeInsurance:
            return (2.0, 4.0)
        case .realEstate:
            return (3.0, 6.0)
        case .bonds:
            return (1.5, 3.5)
        case .custom:
            return (3.0, 8.0)
        }
    }
}
