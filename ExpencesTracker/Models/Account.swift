//
//  Account.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 29.02.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let AccountUpdatedNotification = Notification.Name("AccountUpdatedNotification")

class Account {
    private static var currentAccountInstance: Account?
    
    static var current: Account {
        if let account = currentAccountInstance {
            return account
        }
    
        currentAccountInstance = Account()
        return currentAccountInstance!
    }
    
    init() {
        transactions = transactionData
        tags = tagData
        self.createDefaultTagsIfNeeded()
    }
    
    var transactions: [Transaction] = []
    var transactionsGrouped: [Date: [Transaction]] {
        var result: [Date: [Transaction]] = [:]
        
        for transaction in transactions {
            guard let date = transaction.date else {
                continue
            }
            
            if var list = result[date] {
                list.append(transaction)
            } else {
                result[date] = [transaction]
            }
        }
        
        return result
    }
    
    var transactionsSorted: [Transaction] {
        transactions.sorted { (a, b) -> Bool in
            guard let dateA = a.date, let dateB = b.date else {
                return false
            }
            
            return dateB.distance(to: dateA) > 0
        }
    }
    
    var tags: [TransactionTag] = []

    var balance: Balance {
        return getBalance()
    }
    
    func getSum(from: Date, till: Date) -> Balance {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        request.resultType = .dictionaryResultType
                
        let predicate = NSPredicate(format: "valueDate >= %@ AND valueDate <= %@", from as NSDate, till as NSDate)
        request.predicate = predicate
        
        let expression = NSExpression(format: "sum:(amount)")
        let expressionDescription = NSExpressionDescription()
        
        expressionDescription.expression = expression
        expressionDescription.name = "balance"
        expressionDescription.expressionResultType = .doubleAttributeType
        request.propertiesToFetch = ["type", expressionDescription]
        request.propertiesToGroupBy = ["type"]
        
        let sort = NSSortDescriptor(key: "type", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let result: [NSFetchRequestResult] = try managedContext.fetch(request)
            
            return getBalanceFromResult(result: result, from: from, till: till)
        } catch let error {
            print("Error while calculationg balance: \(error)")
            return Balance()
        }
    }
    
    func getSum() -> Balance {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        request.resultType = .dictionaryResultType
        
//        if let type = type {
//            let predicate = NSPredicate(format: "type = %d", type.rawValue)
//            request.predicate = predicate
//        }
        
        let expression = NSExpression(format: "sum:(amount)")
        let expressionDescription = NSExpressionDescription()
        
        expressionDescription.expression = expression
        expressionDescription.name = "balance"
        expressionDescription.expressionResultType = .doubleAttributeType
        request.propertiesToFetch = ["type", expressionDescription]
        request.propertiesToGroupBy = ["type"]
        
        let sort = NSSortDescriptor(key: "type", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let result: [NSFetchRequestResult] = try managedContext.fetch(request)
            
            return getBalanceFromResult(result: result)
        } catch let error {
            print("Error while calculationg balance: \(error)")
            return Balance()
        }
    }
    
    func getBalanceFromResult(result: [NSFetchRequestResult]) -> Balance {
        return getBalanceFromResult(result: result, from: nil, till: nil)
    }
    
    func getBalanceFromResult(result: [NSFetchRequestResult], from: Date?, till: Date?) -> Balance {
        let income:Double = result.count > 0 ? (result[0] as! Dictionary)["balance"] ?? 0 : 0
        let expense: Double = result.count > 1 ? (result[1] as! Dictionary)["balance"] ?? 0 : 0
        
        return Balance(
            income: Money(amount: income),
            expence: Money(amount: expense),
            from: from,
            till: till
        )
    }
    
    func getSum(tagID: NSManagedObjectID?) -> Balance {
        guard let objectID = tagID else {
            return Balance()
        }
        
        guard let tag = getTag(objectID: objectID) else {
            return Balance()
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        request.resultType = .dictionaryResultType
        
        let predicate = NSPredicate(format: "ANY tags = %@", tag)
        request.predicate = predicate
        
        let expression = NSExpression(format: "sum:(amount)")
        let expressionDescription = NSExpressionDescription()
        
        expressionDescription.expression = expression
        expressionDescription.name = "balance"
        expressionDescription.expressionResultType = .doubleAttributeType
        request.propertiesToFetch = [expressionDescription]
        
        request.propertiesToFetch = ["type", expressionDescription]
        request.propertiesToGroupBy = ["type"]
        
        let sort = NSSortDescriptor(key: "type", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let result: [NSFetchRequestResult] = try managedContext.fetch(request)
            
            return getBalanceFromResult(result: result)
        } catch let error {
            print("Error while calculationg balance: \(error)")
            return Balance()
        }
    }
    
    func getBalance() -> Balance {
        let now = Date()
        
        let cal = Calendar(identifier: .gregorian)
        var componentsFrom = cal.dateComponents([.year, .month, .day], from: now)
        componentsFrom.day = 1
        
        let from = cal.date(from: componentsFrom) ?? Date()
        
        let till = cal.date(byAdding: DateComponents(month: 1, day: -1), to: from) ?? Date()
        
        return getSum(from: from, till: till)
        
//        return transactions.reduce(0) {
//            (result, transaction) -> Double in
//            if (.expense == transaction.type) {
//                return result - abs(transaction.amount ?? 0)
//            } else {
//                return result + abs(transaction.amount ?? 0)
//            }
//        }
    }
    
    func getBalanceTitle() -> String {
        String(format:"Balance: %.2f", Account.current.getBalance().total.amount)
    }
    
    func add(transaction: Transaction) {
        transactions.append(transaction)
        NotificationCenter.default.post(Notification(name: AccountUpdatedNotification))
    }
    
    func process(model: TagViewModel) {
        if model.isDraft {
            print("Creating new tag")
            let entity = NSEntityDescription.entity(forEntityName: "TagEntity", in: managedContext)!
            
            let object = NSManagedObject(entity: entity, insertInto: managedContext)
            object.setValue(model.name, forKey: "name")
            object.setValue(Date(), forKey: "createdAt")
            object.setValue(model.icon, forKey: "icon")
            object.setValue(model.note, forKey: "note")
            object.setValue(model.type.rawValue, forKey: "type")
        } else if let objectID = model.objectID {
            let request: NSFetchRequest<TagEntity> = NSFetchRequest(entityName: "TagEntity")
            
            request.predicate = NSPredicate(format: "SELF = %@", objectID)

            do {
                let fetchResult = try managedContext.fetch(request)
                if let existingTag = fetchResult.first {
                    print("Updating existing tag")
                    existingTag.name = model.name
//                    existingTag.setValue(model.name, forKey: "name")
                    existingTag.icon = model.icon
                    existingTag.note = model.note
                    existingTag.type = Int16(model.type.rawValue)
                } else {
                    print("No tag found :(")
                }
            } catch let error as NSError {
              print("Could not load. \(error), \(error.userInfo)")
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func getTag(objectID: NSManagedObjectID) -> TagEntity? {
        let request: NSFetchRequest<TagEntity> = NSFetchRequest(entityName: "TagEntity")
        
        request.predicate = NSPredicate(format: "SELF = %@", objectID)

        do {
            let fetchResult = try managedContext.fetch(request)
            return fetchResult.first
        } catch let error as NSError {
          print("Could not load. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func tagsCount() -> Int {
        let request: NSFetchRequest<TagEntity> = NSFetchRequest(entityName: "TagEntity")
        do {
            let fetchResult = try managedContext.fetch(request)
            return fetchResult.count
        } catch let error as NSError {
          print("Could not load. \(error), \(error.userInfo)")
        }
        return 0
    }
    
    func process(transactionViewModel model: TransactionViewModel) {
        
        if model.isDraft {
            let entity = NSEntityDescription.entity(forEntityName: "TransactionEntity", in: managedContext)!
            
            let transaction = NSManagedObject(entity: entity, insertInto: managedContext) as! TransactionEntity
            transaction.setValue(model.amount, forKey: "amount")
            transaction.setValue(Date(), forKey: "createdAt")
            transaction.setValue(model.valueDate, forKey: "valueDate")
            transaction.setValue(model.transactionType.rawValue, forKey: "type")
            transaction.tags = getTagsFromModels(models: model.tags)
        } else if let objectID = model.objectID {
            let request: NSFetchRequest<TransactionEntity> = NSFetchRequest(entityName: "TransactionEntity")
            request.predicate = NSPredicate(format: "SELF = %@", objectID)

            do {
                let fetchResult = try managedContext.fetch(request)
                if let existingTransaction = fetchResult.first {
                    existingTransaction.amount = model.amount
                    existingTransaction.valueDate = model.valueDate
                    existingTransaction.setValue(model.amount, forKey: "amount")
                    
                    existingTransaction.tags = getTagsFromModels(models: model.tags)
                    
                    print("\(existingTransaction)")
                }
            } catch let error as NSError {
              print("Could not load. \(error), \(error.userInfo)")
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
        NotificationCenter.default.post(Notification(name: AccountUpdatedNotification))
    }
    
    func getTagsFromModels(models: [TagViewModel]) -> NSSet {
        return NSSet(array: models.map({
            (model) -> TagEntity? in
            
            if let objectID = model.objectID {
                return self.getTag(objectID: objectID)
            }
            
            return nil
        }))
    }
    
    private var managedContext: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func getTag(id: String) -> TransactionTag {
        for tag in tags {
            if tag.id == id {
                return tag
            }
        }
        
        return TransactionTag(id: "-", name: "-", icon: "👾")
    }
    
    func loadTransactions() {
        let managedContext =
          (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // 2
//        let entity = NSEntityDescription.entity(forEntityName: "TransactionEntity", in: managedContext)!
        
//        let transaction = NSManagedObject(entity: entity, insertInto: managedContext)
//        transaction.setValue(200, forKey: "amount")
//        transaction.setValue(Date(), forKey: "createdAt")
//        transaction.setValue(Date(), forKey: "valueDate")
//        transaction.setValue(1, forKey: "type")
        
        do {
//            try managedContext.save()
            
            let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TransactionEntity")
            let transactions = try managedContext.fetch(fetchRequest)
            
            print("Total \(transactions.count) transactions")
            
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func createDefaultTagsIfNeeded() {
        let defaultTags = [
            TagViewModel(name: "Coffee", icon: "☕️", note: "", type: .expense),
            TagViewModel(name: "Groceries", icon: "🛒", note: "", type: .expense),
            TagViewModel(name: "Salary", icon: "💰", note: "", type: .income),
            TagViewModel(name: "Savings", icon: "🏦", note: "It's a good habbit to save at least 10% of your total income", type: .expense),
            TagViewModel(name: "Taxi", icon: "🚕", note: "", type: .expense),
            TagViewModel(name: "Public transport", icon: "🚎", note: "", type: .expense),
            TagViewModel(name: "Eating out", icon: "🍱", note: "", type: .expense),
            TagViewModel(name: "Other", icon: "🦄", note: "", type: .expense),
            TagViewModel(name: "Education", icon: "🎓", note: "", type: .expense),
            TagViewModel(name: "Hobby", icon: "🎹", note: "", type: .expense),
        ]
            
        print("tags count \(tagsCount())")
        
        if 0 == tagsCount() {
            for tag in defaultTags {
                print("creating tag \(tag.name)")
                self.process(model: tag)
            }
        }
    }
}
