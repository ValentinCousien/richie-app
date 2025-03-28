//
//  AmountInput.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI

struct AmountInput: View {
    let title: String
    @Binding var value: Double
    let width: CGFloat

    init(title: String, value: Binding<Double>, width: CGFloat = 120) {
        self.title = title
        self._value = value
        self.width = width
    }

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            TextField(String(localized: "field.amount"), value: $value, format: .number)
                .multilineTextAlignment(.trailing)
                .frame(width: width)
        }
    }
}
