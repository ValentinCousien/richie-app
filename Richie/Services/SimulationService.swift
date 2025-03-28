//
//  SimulationService.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//
import Foundation
import Combine

@Observable
class SimulationService {
    private var cancellables = Set<AnyCancellable>()

    func simulateInvestment(_ investment: Investment) -> SimulationResult {
        // Validate duration to prevent negative values
        let duration = max(1, investment.duration)

        var months: [Int] = []
        var lowEstimateValues: [Double] = []
        var highEstimateValues: [Double] = []

        // Protect against invalid rates
        let lowEstimateRate = max(0, investment.lowEstimateRate)
        let highEstimateRate = max(0, investment.highEstimateRate)

        let monthlyLowRate = pow(1 + lowEstimateRate / 100, 1.0/12) - 1
        let monthlyHighRate = pow(1 + highEstimateRate / 100, 1.0/12) - 1

        var lowCurrentValue = max(0, investment.initialAmount)
        var highCurrentValue = max(0, investment.initialAmount)

        for month in 0...duration {
            months.append(month)

            // Add regular contributions if applicable
            if let contribution = investment.regularContributions {
                let contributionAmount = max(0, contribution.amount)

                switch contribution.frequency {
                case .monthly:
                    lowCurrentValue += contributionAmount
                    highCurrentValue += contributionAmount
                case .quarterly:
                    if month % 3 == 0 && month > 0 {
                        lowCurrentValue += contributionAmount
                        highCurrentValue += contributionAmount
                    }
                case .annually:
                    if month % 12 == 0 && month > 0 {
                        lowCurrentValue += contributionAmount
                        highCurrentValue += contributionAmount
                    }
                }
            }

            // Apply monthly growth rate
            if month > 0 {
                lowCurrentValue *= (1 + monthlyLowRate)
                highCurrentValue *= (1 + monthlyHighRate)
            }

            // Make sure we don't store any NaN or infinite values
            if lowCurrentValue.isNaN || lowCurrentValue.isInfinite {
                lowCurrentValue = 0
            }

            if highCurrentValue.isNaN || highCurrentValue.isInfinite {
                highCurrentValue = 0
            }

            lowEstimateValues.append(lowCurrentValue)
            highEstimateValues.append(highCurrentValue)
        }

        return SimulationResult(
            months: months,
            lowEstimateValues: lowEstimateValues,
            highEstimateValues: highEstimateValues
        )
    }

    func combinedSimulation(investments: [Investment]) -> SimulationResult {
        // Find the longest investment duration
        let maxDuration = max(1, investments.map { max(1, $0.duration) }.max() ?? 0)

        var months: [Int] = Array(0...maxDuration)
        var combinedLowValues = Array(repeating: 0.0, count: maxDuration + 1)
        var combinedHighValues = Array(repeating: 0.0, count: maxDuration + 1)

        for investment in investments {
            let result = simulateInvestment(investment)

            // Add the simulated values to the combined totals
            for (index, month) in result.months.enumerated() {
                guard index < result.lowEstimateValues.count &&
                      index < result.highEstimateValues.count &&
                      month <= maxDuration else {
                    continue
                }

                let lowVal = result.lowEstimateValues[index]
                let highVal = result.highEstimateValues[index]

                if !lowVal.isNaN && !lowVal.isInfinite {
                    combinedLowValues[month] += lowVal
                }

                if !highVal.isNaN && !highVal.isInfinite {
                    combinedHighValues[month] += highVal
                }
            }
        }

        return SimulationResult(
            months: months,
            lowEstimateValues: combinedLowValues,
            highEstimateValues: combinedHighValues
        )
    }
}
