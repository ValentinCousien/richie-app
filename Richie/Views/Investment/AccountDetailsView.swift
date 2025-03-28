//
//  AccountDetailsView.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI

struct AccountDetailView: View {
    let accountType: InvestmentAccountType

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(accountType.localizedName)
                    .font(.largeTitle)
                    .bold()

                Divider()

                Text(InvestmentRulesManager.shared.getAccountTypeDescription(accountType))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle(String(localized: "title.account.details"))
    }
}
