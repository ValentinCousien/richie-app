//
//  AddInvestmentView.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI

//struct AddInvestmentView: View {
//    let onSave: (Investment) -> Void
//
//    @Environment(\.dismiss) private var dismiss
//
//    @State private var name = ""
//    @State private var initialAmount = 10000.0
//    @State private var investmentType = InvestmentType.stocks
//    @State private var startDate = Date()
//    @State private var duration = 30 // Years
//    @State private var lowEstimateRate: Double = 0
//    @State private var highEstimateRate: Double = 0
//    @State private var includeContributions = false
//    @State private var contributionAmount = 500.0
//    @State private var contributionFrequency = ContributionFrequency.monthly
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text(String(localized: "section.basic.information"))) {
//                    TextField(String(localized: "field.investment.name"), text: $name)
//
//                    Picker(String(localized: "field.investment.type"), selection: $investmentType) {
//                        ForEach(InvestmentType.allCases, id: \.self) { type in
//                            Text(type.localizedName).tag(type)
//                        }
//                    }
//                    .onChange(of: investmentType) { newValue in
//                        lowEstimateRate = newValue.defaultRates.low
//                        highEstimateRate = newValue.defaultRates.high
//                    }
//
//                    HStack {
//                        Text(String(localized: "field.initial.amount"))
//                        Spacer()
//                        TextField(String(localized: "field.amount"), value: $initialAmount, format: .number)
//                            .multilineTextAlignment(.trailing)
//                            .frame(width: 120)
//                    }
//                }
//
//                Section(header: Text(String(localized: "section.timeframe"))) {
//                    DatePicker(String(localized: "field.start.date"), selection: $startDate, displayedComponents: .date)
//                    Stepper(
//                        value: $duration,
//                        in: 1...50,
//                        step: 1
//                    ) {
//                        Text(String(format: String(localized: "field.duration.years"), duration))
//                    }
//                }
//
//                Section(header: Text(String(localized: "section.growth.rates"))) {
//                    HStack {
//                        Text(String(localized: "field.low.estimate"))
//                        Spacer()
//                        TextField(String(localized: "field.rate"), value: $lowEstimateRate, format: .number)
//                            .multilineTextAlignment(.trailing)
//                            .frame(width: 80)
//                        Text("%")
//                    }
//
//                    HStack {
//                        Text(String(localized: "field.high.estimate"))
//                        Spacer()
//                        TextField(String(localized: "field.rate"), value: $highEstimateRate, format: .number)
//                            .multilineTextAlignment(.trailing)
//                            .frame(width: 80)
//                        Text("%")
//                    }
//                }
//
//                Section(header: Text(String(localized: "section.regular.contributions"))) {
//                    Toggle(String(localized: "field.include.contributions"), isOn: $includeContributions)
//
//                    if includeContributions {
//                        HStack {
//                            Text(String(localized: "field.contribution.amount"))
//                            Spacer()
//                            TextField(String(localized: "field.amount"), value: $contributionAmount, format: .number)
//                                .multilineTextAlignment(.trailing)
//                                .frame(width: 120)
//                        }
//
//                        Picker(String(localized: "field.frequency"), selection: $contributionFrequency) {
//                            ForEach(ContributionFrequency.allCases, id: \.self) { frequency in
//                                Text(frequency.localizedName).tag(frequency)
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle(String(localized: "title.add.investment"))
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button(String(localized: "action.cancel")) {
//                        dismiss()
//                    }
//                }
//
//                ToolbarItem(placement: .confirmationAction) {
//                    Button(String(localized: "action.add")) {
//                        let endDate = Calendar.current.date(byAdding: .year, value: duration, to: startDate)!
//
//                        let regularContributions = includeContributions ?
//                            RegularContribution(amount: contributionAmount, frequency: contributionFrequency) : nil
//
//                        let investment = Investment(
//                            name: name,
//                            initialAmount: initialAmount,
//                            investmentType: investmentType,
//                            startDate: startDate,
//                            endDate: endDate,
//                            lowEstimateRate: lowEstimateRate,
//                            highEstimateRate: highEstimateRate,
//                            regularContributions: regularContributions
//                        )
//
//                        onSave(investment)
//                        dismiss()
//                    }
//                    .disabled(name.isEmpty)
//                }
//            }
//            .onAppear {
//                // Set default rates based on investment type
//                lowEstimateRate = investmentType.defaultRates.low
//                highEstimateRate = investmentType.defaultRates.high
//            }
//        }
//    }
//}
