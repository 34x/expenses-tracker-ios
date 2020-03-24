//
//  TransactionListSection.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 17.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TransactionListSection: View {
    var range: DateRange
    
    var body: some View {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        let balance = Account.current.balance(range: range)
        
        let dateTitle = formatter.string(from: range.from)
        
        let header = HStack {
            Text(dateTitle)
            Spacer()
            Text(balance.total.string)
        }
        
        return Section(
            header: header,
            content: {
                ForEach(Account.current.transactions(range: range)) {
                    transaction -> NavigationLink<TransactionRow, TransactionDetails> in
                    
                    let model = TransactionViewModel(transaction: transaction)

                    return NavigationLink(
                        destination: TransactionDetails(transactionViewModel: model),
                        label: {
                            TransactionRow(viewModel: model)
                    })
                }
            })
    }
}

struct TransactionListSection_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListSection(range: DateRange(year: 2020, month: 03))
    }
}