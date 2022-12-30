//
//  CustomTabifyBarStyle.swift
//  encoreApp
//
//  Created by Benedikt Geisberger on 29.12.22.
//  Copyright © 2022 NikolaiEtienne. All rights reserved.
//

import SwiftUI
import Tabify

struct CustomTabifyBarStyle: BarStyle {
    public func bar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> some View {
        VStack {
            itemsContainer()
                .padding(.horizontal, 55.0)
                .frame(height: 70.0)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .padding(.top, 25.0)
        }
        .frame(height: 80.0 + geometry.safeAreaInsets.bottom)
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), location: 0),
                            .init(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), location: 0.265625)
                        ]),
                        startPoint: UnitPoint(x: 0.5, y: -3.0616171314629196e-17),
                        endPoint: UnitPoint(x: 0.5, y: 1.0)
                    )
                )
        )
    }
}
