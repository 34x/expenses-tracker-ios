//
//  HistoryScreen.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 18.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

enum ViewBy: Int {
    case transactions = 1
    case tags = 2
}

struct HistoryScreen: View {
    @State private var balanceTitle: String = ""
    @State private var selectedView:ViewBy = .transactions
    
    var body: some View {
        let days = Account.current.getDaysList()
        let months = Account.current.getMonthsList()

        return NavigationView {
            VStack {
                Picker("View by", selection: $selectedView) {
                    Text("Transactions").tag(ViewBy.transactions)
                    Text("Tags").tag(ViewBy.tags)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                List {
                    if (self.selectedView == .transactions) {
                        ForEach(days) {
                            range -> TransactionListSection in
                                
                            TransactionListSection(range: range)
                        }
                    } else {
                        ForEach(months) {
                            range -> HistorySection in
                            HistorySection(range: range)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            // seems like without the title bar can not be hidden, SwiftUI bug?
            .navigationBarTitle("Transactions list")
        }
    }
}

struct HistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
    }
}
