//
//  PortfolioOverview.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI
import Charts

struct PortfolioOverview: View {
    let investments: [Investment]
    private let simulationService = SimulationService()

    var body: some View {
        let result = simulationService.combinedSimulation(investments: investments)

        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(String(localized: "label.total.value"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(CurrencyFormatter.shared.formatCompactCurrency(result.highEstimateValues.last ?? 0))
                        .font(.title2)
                        .bold()
                }

                Spacer()
            }
            .padding(.bottom, 8)

            CombinedChartView(result: result)
                .frame(height: 300)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
