//
//  TransactionList.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 29.02.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TransactionList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: TransactionEntity.allEntities()) var transactions: FetchedResults<TransactionEntity>
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
        
    var body: some View {
        List {
            ForEach(self.transactions) {
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

struct TransactionList_Previews: PreviewProvider {
    static var previews: some View {
        TransactionList()
    }
}
