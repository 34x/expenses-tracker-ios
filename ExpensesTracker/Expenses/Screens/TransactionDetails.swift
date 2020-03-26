//
//  TransactionDetails.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 29.02.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TransactionDetails: View {
    @Environment(\.presentationMode) var presentation
    
    @State private var viewModel: TransactionViewModel
    
    init(transactionViewModel: TransactionViewModel) {
        _viewModel = State(initialValue: transactionViewModel)
    }
    
    var body: some View {
        let amountField = TextField("Amount", text: self.$viewModel.amountValue)
            .keyboardType(.decimalPad)
            .font(.title)
            .foregroundColor(viewModel.typeColor)
        
        let saveButton = Button(
            action: {
                self.saveAction()
            },
            label: {
                Text("Save")
            }
        )
        
        let tagSelector = TagSelectorView(
            selectedTags: self.viewModel.tags,
            onChange: {
                selected in
                
                self.viewModel.tags = selected
        })

        return
            Form {
                Section(header: Text("Amount")) {
                    amountField
                }
                
                Section {
                    DatePicker(
                        selection: $viewModel.valueDate,
                        displayedComponents: [
                            DatePickerComponents.date, DatePickerComponents.hourAndMinute
                        ],
                        label: {
                            Text("Transaction date")
                    })
                }
                
                Section(header: Text("Tags")) {
                    NavigationLink(
                        destination: tagSelector,
                        label: {
                            TagItemsView(tags: viewModel.tags)
                        }
                    )
                }
                
                Section(header: Text("Note")) {
                    TextField("Note", text: $viewModel.note)
                }
            }
            .navigationBarTitle(viewModel.detailsTitle)
            .navigationBarItems(trailing: saveButton)
            
    }
    
    func saveAction() {
        Account.current.process(transactionViewModel: self.viewModel)
        self.presentation.wrappedValue.dismiss()
    }
    
//    func initKeyboardListener() {
//        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
//        .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
//        .compactMap({ notification in
//          guard let keyboardFrameValue: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return nil }
//          let keyboardFrame = keyboardFrameValue.cgRectValue
//          // If the rectangle is at the bottom of the screen, set the height to 0.
//          if keyboardFrame.origin.y == UIScreen.main.bounds.height {
//            return 0
//          } else {
//            // Adjust for safe area
//            return keyboardFrame.height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
//          }
//        })
//        .assign(to: \.keyboardHeight, on: self)
//        .store(in: &cancellables)
//    }
}

struct TransactionDetails_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetails(
            transactionViewModel: TransactionViewModel(transaction: transactionData[1])
        ).previewLayout(.fixed(width: 400, height: 600))
    }
}
