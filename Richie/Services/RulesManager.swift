//
//  RulesManager.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import Foundation

// MARK: - Investment Rule Types

enum InvestmentRuleType: String, Codable, CaseIterable {
    case depositLimit = "DepositLimit"
    case ageLimit = "AgeLimit"
    case geographicalRestriction = "GeographicalRestriction"
    case incomeLimit = "IncomeLimit"
}

// MARK: - Investment Account Types

enum InvestmentAccountType: String, Codable, CaseIterable, Identifiable {
    case standard = "Standard"
    case pea = "PEA"
    case peaPme = "PEA-PME"
    case lifeInsurance = "LifeInsurance"
    case perp = "PERP"
    case pel = "PEL"

    var id: String { self.rawValue }

    var localizedName: String {
        switch self {
        case .standard:
            String(localized: "account.type.standard")
        case .pea:
            String(localized: "account.type.pea")
        case .peaPme:
            String(localized: "account.type.peaPme")
        case .lifeInsurance:
            String(localized: "account.type.lifeInsurance")
        case .perp:
            String(localized: "account.type.perp")
        case .pel:
            String(localized: "account.type.pel")
        }
    }

    var description: String {
        switch self {
        case .standard:
            String(localized: "account.description.standard")
        case .pea:
            String(localized: "account.description.pea")
        case .peaPme:
            String(localized: "account.description.peaPme")
        case .lifeInsurance:
            String(localized: "account.description.lifeInsurance")
        case .perp:
            String(localized: "account.description.perp")
        case .pel:
            String(localized: "account.description.pel")
        }
    }

    // Get applicable investment types for this account
    var allowedInvestmentTypes: [InvestmentType] {
        switch self {
        case .standard:
            [.stocks, .bonds, .scpi, .realEstate, .lifeInsurance, .savings, .custom]
        case .pea, .peaPme:
            [.stocks]
        case .lifeInsurance:
            [.lifeInsurance]
        case .perp:
            [.bonds, .stocks]
        case .pel:
            [.savings]
        }
    }
}

// MARK: - Investment Rule Protocol

protocol InvestmentRule {
    var type: InvestmentRuleType { get }
    var accountType: InvestmentAccountType { get }
    var description: String { get }

    func validateInvestment(_ investment: Investment) -> Bool
    func getValidationError(_ investment: Investment) -> String?
}

// MARK: - Deposit Limit Rule

struct DepositLimitRule: InvestmentRule {
    let type: InvestmentRuleType = .depositLimit
    let accountType: InvestmentAccountType
    let maxAmount: Double

    var description: String {
        String(localized: "rule.deposit.limit.description \(Int(maxAmount))")
    }

    func validateInvestment(_ investment: Investment) -> Bool {
        // A real implementation would track total deposits
        // This is simplified for demo purposes
        investment.initialAmount <= maxAmount
    }

    func getValidationError(_ investment: Investment) -> String? {
        if !validateInvestment(investment) {
            return String(localized: "rule.deposit.limit.error \(Int(maxAmount))")
        }
        return nil
    }
}

// MARK: - Age Limit Rule

struct AgeLimitRule: InvestmentRule {
    let type: InvestmentRuleType = .ageLimit
    let accountType: InvestmentAccountType
    let minAge: Int
    let maxAge: Int?

    var description: String {
        if let maxAge = maxAge {
            return String(localized: "rule.age.limit.range.description \(minAge) \(maxAge)")
        } else {
            return "\(String(localized: "rule.age.limit.min.description"))\(minAge)"
        }
    }

    func validateInvestment(_ investment: Investment) -> Bool {
        // In a real app, you would calculate age from user profile
        // This is simplified for demo purposes
        return true
    }

    func getValidationError(_ investment: Investment) -> String? {
        if !validateInvestment(investment) {
            if let maxAge = maxAge {
                return String(localized: "rule.age.limit.range.error \(minAge) \(maxAge)")
            } else {
                return String(localized: "rule.age.limit.min.error \(minAge)")
            }
        }
        return nil
    }
}

// MARK: - Geographical Restriction Rule

struct GeographicalRestrictionRule: InvestmentRule {
    let type: InvestmentRuleType = .geographicalRestriction
    let accountType: InvestmentAccountType
    let allowedCountries: [String]

    var description: String {
        let countriesString = allowedCountries.joined(separator: ", ")
        return String(localized: "rule.geographical.restriction.description \(countriesString)")
    }

    func validateInvestment(_ investment: Investment) -> Bool {
        // In a real app, you would check user's country
        // This is simplified for demo purposes
        return true
    }

    func getValidationError(_ investment: Investment) -> String? {
        if !validateInvestment(investment) {
            let countriesString = allowedCountries.joined(separator: ", ")
            return String(localized: "rule.geographical.restriction.error \(countriesString)")
        }
        return nil
    }
}

// MARK: - Rules Manager

class InvestmentRulesManager {
    static let shared = InvestmentRulesManager()

    private var rules: [InvestmentAccountType: [InvestmentRule]] = [:]

    private init() {
        setupRules()
    }

    private func setupRules() {
        // PEA rules
        let peaDepositRule = DepositLimitRule(accountType: .pea, maxAmount: 150000)
        let peaAgeRule = AgeLimitRule(accountType: .pea, minAge: 18, maxAge: nil)
        let peaGeoRule = GeographicalRestrictionRule(accountType: .pea,
                                                   allowedCountries: ["France"])
        rules[.pea] = [peaDepositRule, peaAgeRule, peaGeoRule]

        // PEA-PME rules
        let peaPmeDepositRule = DepositLimitRule(accountType: .peaPme, maxAmount: 225000)
        rules[.peaPme] = [peaPmeDepositRule, peaAgeRule, peaGeoRule]

        // Life Insurance rules
        let lifeInsuranceAgeRule = AgeLimitRule(accountType: .lifeInsurance, minAge: 18, maxAge: nil)
        rules[.lifeInsurance] = [lifeInsuranceAgeRule]

        // PERP rules
        let perpAgeRule = AgeLimitRule(accountType: .perp, minAge: 18, maxAge: nil)
        rules[.perp] = [perpAgeRule]

        // PEL rules
        let pelDepositRule = DepositLimitRule(accountType: .pel, maxAmount: 61200)
        let pelAgeRule = AgeLimitRule(accountType: .pel, minAge: 12, maxAge: nil)
        rules[.pel] = [pelDepositRule, pelAgeRule]
    }

    func getRules(for accountType: InvestmentAccountType) -> [InvestmentRule] {
        return rules[accountType] ?? []
    }

    func validateInvestment(_ investment: Investment, for accountType: InvestmentAccountType) -> [String] {
        var errors: [String] = []

        // Check if investment type is allowed for this account
        if !accountType.allowedInvestmentTypes.contains(investment.investmentType) {
            errors.append(String(localized: "rule.investment.type.error \(investment.investmentType.localizedName) \(accountType.localizedName)"))
        }

        // Check all rules for this account type
        if let accountRules = rules[accountType] {
            for rule in accountRules {
                if let error = rule.getValidationError(investment) {
                    errors.append(error)
                }
            }
        }

        return errors
    }

    func getAccountTypeDescription(_ accountType: InvestmentAccountType) -> String {
        var description = accountType.description + "\n\n"

        // Add rules descriptions
        if let accountRules = rules[accountType], !accountRules.isEmpty {
            description += String(localized: "rules.header") + ":\n"
            for rule in accountRules {
                description += "• " + rule.description + "\n"
            }
        }

        // Add allowed investment types
        let allowedTypes = accountType.allowedInvestmentTypes
        if !allowedTypes.isEmpty {
            description += "\n" + String(localized: "allowed.investments.header") + ":\n"
            for type in allowedTypes {
                description += "• " + type.localizedName + "\n"
            }
        }

        return description
    }
}
