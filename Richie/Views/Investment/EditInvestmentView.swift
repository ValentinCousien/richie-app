//
//  EditInvestmentView.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI

struct EditInvestmentView: View {
    let investment: Investment
    let onSave: (Investment) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var initialAmount: Double
    @State private var investmentType: InvestmentType
    @State private var startDate: Date
    @State private var duration: Int
    @State private var lowEstimateRate: Double
    @State private var highEstimateRate: Double
    @State private var includeContributions: Bool
    @State private var contributionAmount: Double
    @State private var contributionFrequency: ContributionFrequency

    init(investment: Investment, onSave: @escaping (Investment) -> Void) {
        self.investment = investment
        self.onSave = onSave

        // Initialize state with current investment values
        _name = State(initialValue: investment.name)
        _initialAmount = State(initialValue: investment.initialAmount)
        _investmentType = State(initialValue: investment.investmentType)
        _startDate = State(initialValue: investment.startDate)

        // Calculate duration in years from months
        let durationInYears = max(1, investment.duration / 12)
        _duration = State(initialValue: durationInYears)

        _lowEstimateRate = State(initialValue: investment.lowEstimateRate)
        _highEstimateRate = State(initialValue: investment.highEstimateRate)

        // Initialize contribution info
        let hasContributions = investment.regularContributions != nil
        _includeContributions = State(initialValue: hasContributions)

        if let contributions = investment.regularContributions {
            _contributionAmount = State(initialValue: contributions.amount)
            _contributionFrequency = State(initialValue: contributions.frequency)
        } else {
            _contributionAmount = State(initialValue: 500.0)
            _contributionFrequency = State(initialValue: .monthly)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(String(localized: "section.basic.information"))) {
                    TextField(String(localized: "field.investment.name"), text: $name)

                    Picker(String(localized: "field.investment.type"), selection: $investmentType) {
                        ForEach(InvestmentType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }

                    HStack {
                        Text(String(localized: "field.initial.amount"))
                        Spacer()
                        TextField(String(localized: "field.amount"), value: $initialAmount, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 120)
                    }
                }

                Section(header: Text(String(localized: "section.timeframe"))) {
                    DatePicker(String(localized: "field.start.date"), selection: $startDate, displayedComponents: .date)
                    Stepper(
                        value: $duration,
                        in: 1...50,
                        step: 1
                    ) {
                        Text(String(format: String(localized: "field.duration.years"), duration))
                    }
                }

                Section(header: Text("section.growth.rates")) {
                    HStack {
                        Text("field.low.estimate")
                        Spacer()
                        TextField(String(localized: "field.rate"), value: $lowEstimateRate, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("%")
                    }

                    HStack {
                        Text("field.high.estimate")
                        Spacer()
                        TextField(String(localized: "field.rate"), value: $highEstimateRate, format: .number)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("%")
                    }
                }

                Section(header: Text("section.regular.contributions")) {
                    Toggle(String(localized: "field.include.contributions"), isOn: $includeContributions)

                    if includeContributions {
                        HStack {
                            Text("field.contribution.amount")
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
            .navigationTitle(String(localized: "title.edit.investment"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "action.cancel")) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "action.save")) {
                        let endDate = Calendar.current.date(byAdding: .year, value: duration, to: startDate)!

                        let regularContributions = includeContributions ?
                            RegularContribution(amount: contributionAmount, frequency: contributionFrequency) : nil

                        let updatedInvestment = Investment(
                            name: name,
                            initialAmount: initialAmount,
                            investmentType: investmentType,
                            startDate: startDate,
                            endDate: endDate,
                            lowEstimateRate: lowEstimateRate,
                            highEstimateRate: highEstimateRate,
                            regularContributions: regularContributions
                        )

                        onSave(updatedInvestment)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
