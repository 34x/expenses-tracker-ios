//
//  NewTRansactionLink.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 07.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct NewTransactionLink: View {
    var type: TransactionType
    
    var body: some View {
        
        
        let title = Text(TransactionType.income == type ? "Income" : "Expense")
        
        let icon = TransactionType.income == type ? "plus" : "minus"
        
        let destination = TransactionDetailsScreen(
            transactionViewModel: TransactionViewModel(transaction: Transaction(type: type)))
        
        return NavigationLink(
            destination: destination,
            label: {
                HStack {
                    Image(systemName: icon)
                    title
                }
            })
    }
}

struct NewTRansactionLink_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewTransactionLink(type: .expense)
            NewTransactionLink(type: .income)
        }.previewLayout(.fixed(width: 400, height: 64))
    }
}
