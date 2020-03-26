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
    @EnvironmentObject var moneyFormatter: MoneyFormatter
    @EnvironmentObject var dateFormatter: ExpensesDateFormatter
    
    var body: some View {
        let balance = Account.current.balance(range: range)
        
        let dateTitle = dateFormatter.string(range.from, type: .TransactionListSection)
        
        let header = HStack {
            Text(dateTitle)
            Spacer()
            Text(moneyFormatter.string(balance.total))
        }
        
        return Section(
            header: header,
            content: {
                ForEach(Account.current.transactions(range: range)) {
                    transaction -> NavigationLink<TransactionRow, TransactionDetailsScreen> in
                    
                    let model = TransactionViewModel(transaction: transaction)

                    return NavigationLink(
                        destination: TransactionDetailsScreen(transactionViewModel: model),
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
