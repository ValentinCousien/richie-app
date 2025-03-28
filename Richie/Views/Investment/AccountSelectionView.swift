//
//  AccountSelectionView.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI

struct AccountSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (InvestmentAccountType) -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(InvestmentAccountType.allCases) { accountType in
                    accountTypeRow(accountType)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onSelect(accountType)
                            dismiss()
                        }
                }
            }
            .navigationTitle(String(localized: "title.select.account.type"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "action.cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }

    private func accountTypeRow(_ accountType: InvestmentAccountType) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(accountType.localizedName)
                .font(.headline)

            Text(accountType.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}
