//
//  CreateTransactionScreen.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 07.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct CreateTransactionScreen: View {
    @FetchRequest(fetchRequest: TagEntity.allEntriesFetchRequest()) var tags: FetchedResults<TagEntity>
    
    @State var balanceTitle: String = ""
    
    // FIXME: Find a better way to update tags list on data change
    @State var tagsListId: Int = 0
    
    var body: some View {
        NavigationView {    
            Form {
                Section(header: Text("New transaction with tag")) {
                    ForEach(self.tags) {
                        tag -> NavigationLink<TagRow, TransactionDetailsScreen> in
                        
                        let model = TagViewModel(tag: tag)
                        
                        let destination = TransactionDetailsScreen(transactionViewModel: TransactionViewModel(type: model.type, tags: [model]))
                                        
                        return NavigationLink(
                            destination: destination,
                            label: {
                                TagRow(model: model, showBalance: true)
                        })
                    }
                }.id(tagsListId)
                
                Section(header: Text("Custom transaction")) {
                    NewTransactionLink(type: .income)
                    NewTransactionLink(type: .expense)
                }
                
                Section {
                    NewTagLink()
                }
            }
            
            .navigationBarTitle(balanceTitle)
            .onAppear() {
                self.balanceTitle = Account.current.getBalanceTitle()
                self.tagsListId += 1
            }
        }
    }
}

struct CreateTransactionScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateTransactionScreen()
    }
}
