//
//  TransactionViewModel.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 01.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

struct TransactionViewModel: Encodable, Identifiable {
    var id: String = ""
    var objectID: NSManagedObjectID?
    
    var amount: Double = 0.0
    var amountValue: String = "" {
        didSet {
            let formatter = NumberFormatter()
            let number = formatter.number(from: amountValue) ?? 0
            amount = Double(truncating: number)
        }
    }
    
    var date: Date = Date()
    var valueDate: Date = Date()
    var note: String = ""
    
    var transactionType: TransactionType = .expense
    var tags: [TagViewModel] = []
    
    var typeColor: Color {
        switch transactionType {
        case .expense:
            return Color(UIColor.systemRed)
        case .income:
            return Color(UIColor.systemGreen)
        default:
            return .orange
        }
    }
    
    var amountValueSigned: String {
        // FIXME: use formatter from env
        let formatter = MoneyFormatter()
        return String(format: "%@ %@", typeSign, formatter.stringUnsigned(Money(amount: self.amount)))
    }
    
    var typeSign: String {
        return transactionType == TransactionType.expense ? "-" : "+"
    }
    
    var isDraft: Bool {
        return "" == id
    }
    
    var detailsTitle: String {
        if isDraft {
            return transactionType == TransactionType.expense ? "New expense" : "New income"
        }
        
        switch transactionType {
        case .expense:
            return "Expense details"
        case .income:
            return "Income details"
        case .unknown:
            return "Unknown details"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case amount
    }
    
    init(transaction: TransactionEntity) {
        self.id = String("\(transaction.objectID)")
        self.objectID = transaction.objectID
        self.amount = abs(transaction.amount)
        
        // FIXME: use formatter from env
        let formatter = MoneyFormatter()
        self.amountValue = formatter.string(Money(amount: self.amount))
    
        self.transactionType = TransactionType(rawValue: Int(transaction.type))!
        self.valueDate = transaction.valueDate ?? Date()
        self.date = transaction.createdAt ?? Date()
        self.tags = self.getTagModels(tagsSet: transaction.tags)
        self.note = transaction.note ?? ""
    }
    
    func getTagModels(tagsSet: NSSet?) -> [TagViewModel] {
        if let tags = tagsSet {

            let newTags = tags.map({
                (tag) -> TagViewModel? in
                
                if let tagEntity = tag as? TagEntity {
                    
                   return TagViewModel(tag: tagEntity)
                }
                
                return nil
            })
            
            return newTags.filter {
                (tag) -> Bool in
                return tag != nil
            } as! [TagViewModel]
        }
        
        return []
    }
    
    init(type: TransactionType) {
        self.transactionType = type
    }
    
    init(type: TransactionType, tags: [TagViewModel]) {
        self.transactionType = type
        self.tags = tags
    }
    
    func hasTag(tagViewModel: TagViewModel) -> Bool {
        for tag in tags {
            if tagViewModel == tag {
                return true
            }
        }
        return false
    }
}
