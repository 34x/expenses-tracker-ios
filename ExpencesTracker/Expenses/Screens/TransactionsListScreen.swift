//
//  HomeView.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 01.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

enum ViewBy: Int {
    case day = 1
    case month = 2
}

struct TransactionsListScreen: View {
    @State private var balanceTitle: String = ""
    @State private var selectedView:ViewBy = .day
    
    var body: some View {
        let days = Account.current.getDaysList()

        return NavigationView {
            VStack {
            Picker("View by", selection: $selectedView) {
                Text("By Day").tag(ViewBy.day)
                Text("By Month").tag(ViewBy.month)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
                
            List {
                ForEach(days) {
                    range -> TransactionListSection in
                    
                    TransactionListSection(range: range)
                }
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
