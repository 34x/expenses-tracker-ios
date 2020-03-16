//
//  Balance.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 16.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation


struct Balance {
    var income: Money = Money(amount: 0)
    var expence: Money = Money(amount: 0)
    
    var from: Date?
    var till: Date?
    
    var total: Money {
        return Money(amount: income.amount - expence.amount)
    }
}
