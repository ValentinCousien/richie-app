//
//  ModifiedAddInvestmentView.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI

struct AddInvestmentView: View {
    @Environment(\.dismiss) private var dismiss

    let onSave: (Investment, InvestmentAccountType?) -> Void

    @State private var name = ""
    @State private var initialAmount = 10000.0
    @State private var investmentType = InvestmentType.stocks
    @State private var startDate = Date()
    @State private var duration = 5 // Years
    @State private var lowEstimateRate: Double = 0
    @State private var highEstimateRate: Double = 0
    @State private var includeContributions = false
    @State private var contributionAmount = 500.0
    @State private var contributionFrequency = ContributionFrequency.monthly

    // Account selection
    @State private var useAccount = false
    @State private var showingAccountSelection = false
    @State private var selectedAccountType: InvestmentAccountType?

    @State private var validationErrors: [String] = []

    var body: some View {
        NavigationView {
            Form {
                // Account section
                Section(header: Text(String(localized: "section.account"))) {
                    Toggle(String(localized: "field.use.account"), isOn: $useAccount)

                    if useAccount {
                        Button(action: {
                            showingAccountSelection = true
                        }) {
                            HStack {
                                Text(String(localized: "field.select.account"))
                                Spacer()
                                if let accountType = selectedAccountType {
                                    Text(accountType.localizedName)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text(String(localized: "field.none.selected"))
                                        .foregroundColor(.secondary)
                                }
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                }

                // Validation errors section
                if !validationErrors.isEmpty {
                    Section(header: Text(String(localized: "section.validation.errors"))) {
                        ForEach(validationErrors, id: \.self) { error in
                            Text(error)
                                .foregroundColor(.red)
                                .font(.subheadline)
                        }
                    }
                }

                // Basic info section
                Section(header: Text(String(localized: "section.basic.information"))) {
                    TextField(String(localized: "field.investment.name"), text: $name)

                    Picker(String(localized: "field.investment.type"), selection: $investmentType) {
                        if let accountType = selectedAccountType, useAccount {
                            ForEach(accountType.allowedInvestmentTypes, id: \.self) { type in
                                Text(type.localizedName).tag(type)
                            }
                        } else {
                            ForEach(InvestmentType.allCases, id: \.self) { type in
                                Text(type.localizedName).tag(type)
                            }
                        }
                    }
                    .onChange(of: investmentType) { newValue in
                        lowEstimateRate = newValue.defaultRates.low
                        highEstimateRate = newValue.defaultRates.high
                        validateInvestment()
                    }

                    HStack {
                        Text(String(localized: "field.initial.amount"))
                        Spacer()
                        TextField(String(localized: "field.amount"), value: $initialAmount, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 120)
                            .onChange(of: initialAmount) { _ in
                                validateInvestment()
                            }
                    }
                }

                // Rest of the form remains the same
                Section(header: Text(String(localized: "section.timeframe"))) {
                    DatePicker(String(localized: "field.start.date"), selection: $startDate, displayedComponents: .date)

                    Stepper(String(localized: "field.duration.years \(duration)"), value: $duration, in: 1...30)
                }

                Section(header: Text(String(localized: "section.growth.rates"))) {
                    HStack {
                        Text(String(localized: "field.low.estimate"))
                        Spacer()
                        TextField(String(localized: "field.rate"), value: $lowEstimateRate, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("%")
                    }

                    HStack {
                        Text(String(localized: "field.high.estimate"))
                        Spacer()
                        TextField(String(localized: "field.rate"), value: $highEstimateRate, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("%")
                    }
                }

                Section(header: Text(String(localized: "section.regular.contributions"))) {
                    Toggle(String(localized: "field.include.contributions"), isOn: $includeContributions)

                    if includeContributions {
                        HStack {
                            Text(String(localized: "field.contribution.amount"))
                            Spacer()
                            TextField(String(localized: "field.amount"), value: $contributionAmount, format: .number)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 120)
                        }

                        Picker(String(localized: "field.frequency"), selection: $contributionFrequency) {
                            ForEach(ContributionFrequency.allCases, id: \.self) { frequency in
                                Text(frequency.localizedName).tag(frequency)
                            }
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "title.add.investment"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "action.cancel")) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "action.add")) {
                        let endDate = Calendar.current.date(byAdding: .year, value: duration, to: startDate)!

                        let regularContributions = includeContributions ?
                            RegularContribution(amount: contributionAmount, frequency: contributionFrequency) : nil

                        let investment = Investment(
                            name: name,
                            initialAmount: initialAmount,
                            investmentType: investmentType,
                            startDate: startDate,
                            endDate: endDate,
                            lowEstimateRate: lowEstimateRate,
                            highEstimateRate: highEstimateRate,
                            regularContributions: regularContributions
                        )

                        onSave(investment, useAccount ? selectedAccountType : nil)
                        dismiss()
                    }
                    .disabled(name.isEmpty || !validationErrors.isEmpty)
                }
            }
            .sheet(isPresented: $showingAccountSelection) {
                AccountSelectionView { accountType in
                    selectedAccountType = accountType
                    validateInvestment()
                }
            }
            .onAppear {
                // Set default rates based on investment type
                lowEstimateRate = investmentType.defaultRates.low
                highEstimateRate = investmentType.defaultRates.high
            }
        }
    }

    private func validateInvestment() {
        validationErrors.removeAll()

        if useAccount, let accountType = selectedAccountType {
            validationErrors = InvestmentRulesManager.shared.validateInvestment(
                createTemporaryInvestment(),
                for: accountType
            )
        }
    }

    private func createTemporaryInvestment() -> Investment {
        let endDate = Calendar.current.date(byAdding: .year, value: duration, to: startDate)!
        let regularContributions = includeContributions ?
            RegularContribution(amount: contributionAmount, frequency: contributionFrequency) : nil

        return Investment(
            name: name,
            initialAmount: initialAmount,
            investmentType: investmentType,
            startDate: startDate,
            endDate: endDate,
            lowEstimateRate: lowEstimateRate,
            highEstimateRate: highEstimateRate,
            regularContributions: regularContributions
        )
    }
}
