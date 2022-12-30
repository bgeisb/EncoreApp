//
//  TabBarView.swift
//  encoreApp
//
//  Created by Benedikt Geisberger on 29.12.22.
//  Copyright © 2022 NikolaiEtienne. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            Text("Menu")
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }

            Text("Order")
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
