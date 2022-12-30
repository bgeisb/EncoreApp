//
//  ActivityIndicator.swift
//  encoreApp
//
//  Created by Nikolai Madlener on 06.07.20.
//  Copyright © 2020 NikolaiEtienne. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: View {
    @State private var isAnimating: Bool = false
    
    var color: Color
    
    var body: some View {
        HStack(spacing: 5.0) {
                    Circle()
                        .fill(color)
                        .frame(width: 10, height: 10)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever())
                    Circle()
                        .fill(color)
                        .frame(width: 10, height: 10)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
                    Circle()
                        .fill(color)
                        .frame(width: 10, height: 10)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
                }
            .onAppear {
                self.isAnimating = true
        }
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {
            print("Pressed")
        }) {
            ZStack {
                
                ActivityIndicator(color: Color.white)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("purpleblue"))
            }
            .modifier(PlainButtonModifier(isDisabled: false))
            
        }
        ActivityIndicator(color: Color.white)
    }
}
