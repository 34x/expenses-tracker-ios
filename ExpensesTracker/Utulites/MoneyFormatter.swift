//
//  MoneyFormatter.swift
//  ExpensesTracker
//
//  Created by Maksim Tuzhilin on 26.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation

class MoneyFormatter: ObservableObject {
    private var formatter: NumberFormatter
    
    init() {
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
    }
    
    func string(_ from: Money) -> String {
        return formatter.string(for: from.amount) ?? ""
    }
    
    func stringUnsigned(_ from: Money) -> String {
        return formatter.string(for: from.amountUnsigned) ?? ""
    }
}
