//
//  InvestmentDetailView.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI

struct InvestmentDetailView: View {
    let investment: Investment
    let onUpdate: (Investment) -> Void
    let onDelete: () -> Void

    @State private var isEditing = false
    @Environment(\.dismiss) private var dismiss

    private let simulationService = SimulationService()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    DetailCard {
                        VStack(alignment: .leading, spacing: 8) {
                            TitleValueRow(
                                title: String(localized: "label.investment.type"),
                                value: investment.investmentType.localizedName
                            )

                            TitleValueRow(
                                title: String(localized: "label.initial.amount"),
                                value: CurrencyFormatter.shared.formatCurrency(investment.initialAmount)
                            )

                            TitleValueRow(
                                title: String(localized: "label.duration"),
                                value: String(repeating: "value.months", count: investment.duration)
                            )

                            TitleValueRow(
                                title: String(localized: "label.low.estimate"),
                                value: CurrencyFormatter.shared.formatPercent(investment.lowEstimateRate)
                            )

                            TitleValueRow(
                                title: String(localized: "label.high.estimate"),
                                value: CurrencyFormatter.shared.formatPercent(investment.highEstimateRate)
                            )

                            if let contribution = investment.regularContributions {
                                TitleValueRow(
                                    title: String(localized: "label.regular.contribution"),
                                    value: "\(CurrencyFormatter.shared.formatCurrency(contribution.amount)) (\(contribution.frequency.localizedName))"
                                )
                            }
                        }
                    }

                    DetailCard {
                        Text(String(localized: "section.growth.projection"))
                            .font(.headline)

                        InvestmentChartView(investment: investment)
                            .frame(height: 250)
                    }

                    DetailCard {
                        let result = simulationService.simulateInvestment(investment)
                        let finalLow = result.lowEstimateValues.last ?? 0
                        let finalHigh = result.highEstimateValues.last ?? 0

                        Text(String(localized: "section.final.projections"))
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 8) {
                            TitleValueRow(
                                title: String(localized: "label.low.estimate"),
                                value: CurrencyFormatter.shared.formatCurrency(finalLow)
                            )

                            TitleValueRow(
                                title: String(localized: "label.high.estimate"),
                                value: CurrencyFormatter.shared.formatCurrency(finalHigh)
                            )

                            let lowGain = finalLow - investment.initialAmount
                            let highGain = finalHigh - investment.initialAmount

                            TitleValueRow(
                                title: String(localized: "label.low.gain"),
                                value: "\(CurrencyFormatter.shared.formatCurrency(lowGain)) (\(CurrencyFormatter.shared.formatPercent((lowGain / investment.initialAmount) * 100)))"
                            )

                            TitleValueRow(
                                title: String(localized: "label.high.gain"),
                                value: "\(CurrencyFormatter.shared.formatCurrency(highGain)) (\(CurrencyFormatter.shared.formatPercent((highGain / investment.initialAmount) * 100)))"
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(investment.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(String(localized: "action.edit")) {
                        isEditing = true
                    }
                }

                ToolbarItem(placement: .destructiveAction) {
                    Button(String(localized: "action.delete")) {
                        onDelete()
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .sheet(isPresented: $isEditing) {
                EditInvestmentView(
                    investment: investment,
                    onSave: { updatedInvestment in
                        onUpdate(updatedInvestment)
                        dismiss()
                    }
                )
            }
        }
    }
}
