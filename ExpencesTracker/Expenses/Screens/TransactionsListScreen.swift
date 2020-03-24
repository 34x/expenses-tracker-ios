//
//  HomeView.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 01.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TransactionsListScreen: View {
    @State private var balanceTitle: String = ""
    
    var body: some View {
        let days = Account.current.getDaysList()

        return NavigationView {
            List {
                ForEach(days) {
                    range -> TransactionListSection in
                    
                    TransactionListSection(range: range)
                }
            }
            .navigationBarHidden(true)
            // seems like without the title bar can not be hidden, SwiftUI bug?
            .navigationBarTitle("Transactions list")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsListScreen()
    }
}
