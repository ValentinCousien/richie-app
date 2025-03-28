//
//  InvestmentRowView.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI

struct InvestmentRowView: View {
    let investment: Investment

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(investment.name)
                    .font(.headline)

                Text(investment.investmentType.localizedName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(CurrencyFormatter.shared.formatCurrency(investment.initialAmount))
                    .font(.headline)

                Text("\(CurrencyFormatter.shared.formatPercent(investment.lowEstimateRate)) - \(CurrencyFormatter.shared.formatPercent(investment.highEstimateRate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
