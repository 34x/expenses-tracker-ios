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
        let months = Account.current.getMonthsList()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY - MMMM"
        return NavigationView {
            List {
                ForEach(months) {
                    range -> TransactionListSection in
                    
                    TransactionListSection(range: range)
                }
            }
            .navigationBarTitle(balanceTitle)
            .navigationBarHidden(true)
            .onAppear() {
                self.balanceTitle = Account.current.getBalanceTitle()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsListScreen()
    }
}
