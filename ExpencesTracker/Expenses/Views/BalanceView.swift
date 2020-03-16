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
    var body: some View {
        VStack {
            dateRange.font(.subheadline)
            HStack {
                Text("Income")
                Spacer()
                Text(balance.income.string)
            }
            HStack {
                Text("Expense")
                Spacer()
                Text(balance.expence.string)
            }
            HStack {
                Text("Total")
                Spacer()
                Text(balance.total.string)
            }.font(.headline)
        }.padding()
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
