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
        let header = BalanceView(balance: Account.current.balance(range: range))
        
        return Section(header: header) {
            ForEach(Account.current.transactions(range: range)) {
                transaction -> NavigationLink<TransactionRow, TransactionDetails> in
                
                let model = TransactionViewModel(transaction: transaction)

                return NavigationLink(
                    destination: TransactionDetails(transactionViewModel: model),
                    label: {
                        TransactionRow(viewModel: model)
                })
            }
        }
    }
}

struct TransactionListSection_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListSection(range: DateRange(year: 2020, month: 03))
    }
}
