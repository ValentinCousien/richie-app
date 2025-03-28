//
//  CurrencyFormatter.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import Foundation

class CurrencyFormatter {
    static let shared = CurrencyFormatter()

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    private let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    func formatCurrency(_ value: Double) -> String {
        return currencyFormatter.string(from: NSNumber(value: value)) ?? "€\(Int(value))"
    }

    func formatCompactCurrency(_ value: Double) -> String {
        if value >= 1_000_000 {
            return currencyFormatter.string(from: NSNumber(value: value / 1_000_000))! + "M"
        } else if value >= 1_000 {
            return currencyFormatter.string(from: NSNumber(value: value / 1_000))! + "K"
        } else {
            return currencyFormatter.string(from: NSNumber(value: value))!
        }
    }

    func formatPercent(_ value: Double) -> String {
        return percentFormatter.string(from: NSNumber(value: value))! + "%"
    }
}
