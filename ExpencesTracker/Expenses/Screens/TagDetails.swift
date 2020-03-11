//
//  TagDetails.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 05.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI
import CoreData

//struct TagDetailsState: Equatable, Identifiable {
//    var id: String
//    var path: String
//    var name: String
//    var icon: String
//    var note: String
//    var type: TransactionType
//
//    var isDraft: Bool {
//        return "" == path
//    }
//
//    init(model: TagViewModel) {
//        self.path = model.path
//        self.id = model.id
//        self.name = model.name
//        self.icon = model.icon
//        self.note = model.note
//        self.type = model.type
//    }
//}

struct TagDetails: View {
    @Environment(\.presentationMode) var presentation
    
    @State var model: TagViewModel
    
    var body: some View {
        let saveButton = Button(
            action: {
                self.saveAction()
            },
            label: {
                Text("Save")
            }
        )
            
        return
                Form {
                    Section(header: Text("Name") ) {
                        TextField("Name", text: self.$model.name)
                    }
                    
                    Section(header: Text("Icon")) {
                        TextField("Icon", text: self.$model.icon)
                    }
                    
                    Section(header: Text("Note")) {
                        TextField("Note", text: self.$model.note)
                    }
                    
                    Section(header: Text("Default transaction type")) {
                        Picker(
                            selection: self.$model.type,
                            label: Text(""),
                            content: {
                                Text("Income").tag(TransactionType.income)
                                Text("Expense").tag(TransactionType.expense)
//                                Text("Unknown").tag(TransactionType.unknown)
                            })
                            .pickerStyle(SegmentedPickerStyle())
                    }
                }
                .navigationBarItems(trailing: saveButton)
            
    }
    
    private func saveAction() {
        Account.current.process(model: self.model)
        self.presentation.wrappedValue.dismiss()
    }
}

struct TagDetails_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TagDetails(model: TagViewModel())
        }
    }
}
