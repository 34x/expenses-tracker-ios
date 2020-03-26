//
//  BalanceView.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 16.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct BalanceView: View {
    var balance: Balance
    @EnvironmentObject var moneyFormatter: MoneyFormatter
    
    var body: some View {
        VStack {
            dateRange.font(.subheadline)
            HStack {
                Text("Income")
                Spacer()
                Text(moneyFormatter.string(balance.income))
            }
            HStack {
                Text("Expense")
                Spacer()
                Text(moneyFormatter.string(balance.expence))
            }
            HStack {
                Text("Total")
                Spacer()
                Text(moneyFormatter.string(balance.total))
            }.font(.headline)
        }
    }
    
    var dateRange: some View {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        if let from = balance.from, let till = balance.till {
            return HStack {
                Text(formatter.string(from: from))
                Spacer()
                Text(formatter.string(from: till))
            }
        }
        
        return HStack {
            Text("")
            Spacer()
            Text("")
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BalanceView(balance: Balance(income: Money(amount: 0), expence: Money(amount: 0)))
            BalanceView(balance: Balance(income: Money(amount: 8000), expence: Money(amount: 1890)))
            BalanceView(balance: Balance(income: Money(amount: 500), expence: Money(amount: 800)))
        }.previewLayout(.fixed(width: 400, height: 100))
    }
}
