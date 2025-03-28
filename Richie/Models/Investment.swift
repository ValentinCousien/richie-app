//
//  AppDelegate.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import Foundation
import SwiftData

@Model
final class Investment: Identifiable {
    var id: UUID = UUID()
    var name: String
    var initialAmount: Double
    var investmentType: InvestmentType
    var startDate: Date
    var endDate: Date
    var lowEstimateRate: Double // Annual percentage
    var highEstimateRate: Double // Annual percentage
    var regularContributions: RegularContribution?

    init(
        name: String,
        initialAmount: Double,
        investmentType: InvestmentType,
        startDate: Date,
        endDate: Date,
        lowEstimateRate: Double,
        highEstimateRate: Double,
        regularContributions: RegularContribution? = nil
    ) {
        self.name = name
        self.initialAmount = initialAmount
        self.investmentType = investmentType
        self.startDate = startDate
        self.endDate = endDate
        self.lowEstimateRate = lowEstimateRate
        self.highEstimateRate = highEstimateRate
        self.regularContributions = regularContributions
    }

    var duration: Int {
        let components = Calendar.current.dateComponents([.month], from: startDate, to: endDate)
        return components.month ?? 0
    }
}
