//
//  InvestmentChartView.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI
import Charts

struct InvestmentChartView: View {
    let investment: Investment
    private let simulationService = SimulationService()

    var body: some View {
        let result = simulationService.simulateInvestment(investment)
        chartView(result: result)
    }

    private func chartView(result: SimulationResult) -> some View {
        Chart {
            // Low estimate line - filtered to remove any potential NaN values
            ForEach(Array(zip(0..<result.months.count, result.months)), id: \.0) { index, month in
                if index < result.lowEstimateValues.count && !result.lowEstimateValues[index].isNaN {
                    LineMark(
                        x: .value(String(localized: "chart.month"), month),
                        y: .value(String(localized: "chart.low.estimate"), result.lowEstimateValues[index])
                    )
                    .foregroundStyle(.blue)
                }
            }

            // High estimate line - filtered to remove any potential NaN values
            ForEach(Array(zip(0..<result.months.count, result.months)), id: \.0) { index, month in
                if index < result.highEstimateValues.count && !result.highEstimateValues[index].isNaN {
                    LineMark(
                        x: .value(String(localized: "chart.month"), month),
                        y: .value(String(localized: "chart.high.estimate"), result.highEstimateValues[index])
                    )
                    .foregroundStyle(.green)
                }
            }

            // Area between lines - filtered to remove any potential NaN values
            ForEach(Array(zip(0..<result.months.count, result.months)), id: \.0) { index, month in
                if index < result.lowEstimateValues.count &&
                   index < result.highEstimateValues.count &&
                   !result.lowEstimateValues[index].isNaN &&
                   !result.highEstimateValues[index].isNaN {
                    AreaMark(
                        x: .value(String(localized: "chart.month"), month),
                        yStart: .value(String(localized: "chart.low"), result.lowEstimateValues[index]),
                        yEnd: .value(String(localized: "chart.high"), result.highEstimateValues[index])
                    )
                    .foregroundStyle(.green.opacity(0.2))
                }
            }
        }
        .chartYAxis {
            AxisMarks(preset: .automatic) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let doubleValue = value.as(Double.self), !doubleValue.isNaN {
                        Text(CurrencyFormatter.shared.formatCurrency(doubleValue))
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(preset: .automatic) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let intValue = value.as(Int.self), intValue % 12 == 0 {
                        Text("\(intValue / 12)")
                    }
                }
            }
        }
    }
}
