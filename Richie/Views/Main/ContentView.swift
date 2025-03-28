//
//  ContentView.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//
import SwiftUI
import SwiftData
import Charts

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var investments: [Investment]
    @Query private var accounts: [InvestmentAccount]

    @State private var showingAddInvestment = false
    @State private var selectedInvestment: Investment?
    @State private var refreshID = UUID()

    private let simulationService = SimulationService()

    var body: some View {
        mainContentView
            .navigationTitle(String(localized: "app.title"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingAddInvestment = true
                    }) {
                        Label(String(localized: "action.add.investment"), systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddInvestment) {
                AddInvestmentView { newInvestment, accountType  in
                    addInvestment(newInvestment, accountType: accountType)
                }
            }
            .sheet(item: $selectedInvestment) { investment in
                InvestmentDetailView(
                    investment: investment,
                    onUpdate: { updatedInvestment in
                        updateInvestment(investment, with: updatedInvestment)
                    },
                    onDelete: {
                        if let index = investments.firstIndex(where: { $0.id == investment.id }) {
                            deleteInvestments(at: IndexSet([index]))
                        }
                    }
                )
            }
    }

    // Main content layout
    private var mainContentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                investmentsSection

                if !investments.isEmpty {
                    portfolioSection
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // Investments list section
    private var investmentsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "section.investments"))
                .font(.headline)

            if investments.isEmpty {
                emptyStateView
            } else {
                investmentsList
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    // Empty state view
    private var emptyStateView: some View {
        Text(String(localized: "message.no.investments"))
            .foregroundColor(.secondary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // List of investments
    private var investmentsList: some View {
        VStack(spacing: 8) {
            ForEach(investments) { investment in
                InvestmentRowView(investment: investment)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedInvestment = investment
                    }
            }
            .onDelete(perform: deleteInvestments)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Portfolio overview section
    private var portfolioSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "section.portfolio.overview"))
                .font(.headline)

            PortfolioOverview(investments: investments)
                .id(refreshID)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    func addInvestment(_ investment: Investment, accountType: InvestmentAccountType?) {
        Task { @MainActor in
            if let accountType = accountType {
                // Find or create account
                let account = accounts.first { $0.accountTypeEnum == accountType } ??
                InvestmentAccount(name: accountType.localizedName, accountType: accountType)

                // Check rules
                let errors = InvestmentRulesManager.shared.validateInvestment(investment, for: accountType)
                if errors.isEmpty {
                    account.investments.append(investment)
                    if account.id == nil {
                        modelContext.insert(account)
                    }
                }
            } else {
                // Regular investment without account
                modelContext.insert(investment)
            }

            try? modelContext.save()
            refreshID = UUID()
        }
    }

    func updateInvestment(_ old: Investment, with updated: Investment) {
        Task { @MainActor in
            // Update properties
            old.name = updated.name
            old.initialAmount = updated.initialAmount
            old.investmentType = updated.investmentType
            old.startDate = updated.startDate
            old.endDate = updated.endDate
            old.lowEstimateRate = updated.lowEstimateRate
            old.highEstimateRate = updated.highEstimateRate
            old.regularContributions = updated.regularContributions

            try? modelContext.save()

            // Delay UI refresh slightly
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            refreshID = UUID()
        }
    }

    func deleteInvestments(at offsets: IndexSet) {
        Task { @MainActor in
            for index in offsets {
                modelContext.delete(investments[index])
            }

            try? modelContext.save()

            // Delay UI refresh slightly
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            refreshID = UUID()
        }
    }
}
