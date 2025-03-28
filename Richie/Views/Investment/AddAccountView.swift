//
//  AddAccountView.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI

struct AddAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var showingAccountTypeSelection = false
    @State private var selectedAccountType: InvestmentAccountType = .standard

    let onSave: (InvestmentAccount) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(String(localized: "section.basic.information"))) {
                    TextField(String(localized: "field.account.name"), text: $name)

                    Button(action: {
                        showingAccountTypeSelection = true
                    }) {
                        HStack {
                            Text(String(localized: "field.account.type"))
                            Spacer()
                            Text(selectedAccountType.localizedName)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }

                Section(header: Text(String(localized: "section.account.rules"))) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(InvestmentRulesManager.shared.getRules(for: selectedAccountType), id: \.type) { rule in
                            Text("• \(rule.description)")
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(String(localized: "title.add.account"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "action.cancel")) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "action.save")) {
                        let account = InvestmentAccount(name: name, accountType: selectedAccountType)
                        onSave(account)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $showingAccountTypeSelection) {
                AccountSelectionView { accountType in
                    selectedAccountType = accountType
                }
            }
        }
    }
}
