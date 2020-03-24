//
//  TransactionRow.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 28.02.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TransactionRow: View {
    var viewModel: TransactionViewModel
    
    var body: some View {
        return HStack() {
            TagItemsView(tags: viewModel.tags)
            Spacer()
            
            Text(viewModel.amountValueSigned)
                .foregroundColor(viewModel.typeColor)
        }
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text(":(")
//            TransactionRow(viewModel: TransactionViewModel(transaction: transactionData[0]))
//            TransactionRow(viewModel: TransactionViewModel(transaction: transactionData[1]))
//            TransactionRow(viewModel: TransactionViewModel(transaction: transactionData[3]))
        }.previewLayout(.fixed(width: 400, height: 80))
    }
}
