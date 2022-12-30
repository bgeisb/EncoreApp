//
//  CustomTabifyItemStyle.swift
//  encoreApp
//
//  Created by Benedikt Geisberger on 29.12.22.
//  Copyright © 2022 NikolaiEtienne. All rights reserved.
//

import SwiftUI
import Tabify

struct CustomTabifyItemStyle: ItemStyle {
    @ViewBuilder
    public func item(icon: String, title: String, isSelected: Bool) -> some View {
        let color: Color = isSelected ? Color.white : Color("Gray03")
        
        if isSelected {
            HStack(spacing: 5.0) {
                Image(systemName: icon)
                    .font(.title2)
                
                Text(title)
                    .font(.caption.bold())
            }
            .fixedSize()
            .foregroundColor(color)
            .padding(.horizontal, 15.0)
            .padding(.vertical, 10.0)
            .background(
                RoundedRectangle(cornerRadius: 50.0)
                    .fill(Color("Blue"))
            )
        } else {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
        }
    }
}
