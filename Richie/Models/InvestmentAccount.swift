//
//  InvestmentAccount.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import Foundation
import SwiftData

@Model
final class InvestmentAccount {
    var id = UUID()
    var name: String
    var accountType: String // Stores InvestmentAccountType.rawValue
    var investments: [Investment] = []

    init(name: String, accountType: InvestmentAccountType) {
        self.name = name
        self.accountType = accountType.rawValue
    }

    var accountTypeEnum: InvestmentAccountType {
        get {
            InvestmentAccountType(rawValue: accountType) ?? .standard
        }
        set {
            accountType = newValue.rawValue
        }
    }

    var totalValue: Double {
        investments.reduce(0) { $0 + $1.initialAmount }
    }
}
