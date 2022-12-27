//
//  ButtonLightModifier.swift
//  encoreApp
//
//  Created by Etienne Köhler on 19.07.20.
//  Copyright © 2020 NikolaiEtienne. All rights reserved.
//

import SwiftUI

struct TextButtonModifier: ViewModifier {
    var isDisabled: Bool
    var foregroundColor: Color = Color("Blue")
    func body(content: Content) -> some View {
        content
            .font(.callout.bold())
            .padding(.horizontal, 15)
            .padding(.vertical, 18)
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(isDisabled ? Color("Teal") : foregroundColor)
            .padding(.horizontal, 25)
    }
}
