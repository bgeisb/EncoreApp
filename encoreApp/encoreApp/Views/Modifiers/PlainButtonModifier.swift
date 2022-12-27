//
//  RoundedButton.swift
//  encoreApp
//
//  Created by Etienne Köhler on 23.06.20.
//  Copyright © 2020 NikolaiEtienne. All rights reserved.
//

import SwiftUI

struct PlainButtonModifier: ViewModifier {
    var isDisabled: Bool
    var backgroundColor: Color = Color("Blue")
    var foregroundColor: Color = Color.white
    func body(content: Content) -> some View {
        content
            .font(.callout.bold())
            .padding(.horizontal, 15)
            .padding(.vertical, 18)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(isDisabled ? Color("Teal") : backgroundColor)
            .foregroundColor(isDisabled ? Color("lightgray") : foregroundColor)
            .cornerRadius(15)
            .padding(.horizontal, 25)
    }
}
