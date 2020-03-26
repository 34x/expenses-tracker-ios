//
//  ExpensesDateFormatter.swift
//  ExpensesTracker
//
//  Created by Maksim Tuzhilin on 26.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation

enum ExpensesDateFormatterType {
    case TransactionListSection
    case HistorySection
    case BalanceView
}

class ExpensesDateFormatter: ObservableObject {
    func string(_ from: Date, type: ExpensesDateFormatterType) -> String {
        let formatter = DateFormatter()
        
        switch (type) {
            case .TransactionListSection:
                formatter.dateStyle = .full
                break
            case .HistorySection:
                formatter.dateFormat = "YYYY MMMM"
                break
            case .BalanceView:
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                break
        }
        
        return formatter.string(from: from)
    }
}
