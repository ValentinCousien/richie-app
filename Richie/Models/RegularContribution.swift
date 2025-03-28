//
//  RegularContribution.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import Foundation
import SwiftData

@Model
final class RegularContribution {
    var amount: Double
    var frequency: ContributionFrequency

    init(amount: Double, frequency: ContributionFrequency) {
        self.amount = amount
        self.frequency = frequency
    }
}

enum ContributionFrequency: String, Codable, CaseIterable {
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case annually = "Annually"

    var localizedName: String {
        switch self {
        case .monthly:
            String(localized: "contribution.frequency.monthly")
        case .quarterly:
            String(localized: "contribution.frequency.quarterly")
        case .annually:
            String(localized: "contribution.frequency.annually")
        }
    }
}

// For SwiftData compatibility
extension ContributionFrequency: Hashable {}
