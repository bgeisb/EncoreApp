//
//  TabifyItems.swift
//  encoreApp
//
//  Created by Benedikt Geisberger on 29.12.22.
//  Copyright © 2022 NikolaiEtienne. All rights reserved.
//

import Foundation
import Tabify

enum TabifyItems: Int, TabifyItem {
        case first = 0
        case second
        case third
        
        var icon: String {
            switch self {
                case .first: return "house"
                case .second: return "magnifyingglass"
                case .third: return "person"
            }
        }
        
        var title: String {
            switch self {
                case .first: return "Queue"
                case .second: return "Search"
                case .third: return "Memebers"
            }
        }
    }
