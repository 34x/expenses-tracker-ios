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
        NavigationView {
            VStack {
                TransactionList()
            }
            .navigationBarTitle(balanceTitle)
            .navigationBarHidden(false)
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
