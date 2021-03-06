//
//  Theme.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 07.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct Theme {
    var expense = Color(UIColor.systemRed)
    var income = Color(UIColor.systemGreen)
    
    func balanceColor(balance: Balance) -> Color {
        if balance.total.amount > 0 {
            return income
        }
        
        return expense
    }
}
