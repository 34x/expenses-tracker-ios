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
        self.createDefaultTagsIfNeeded()
    }
    
    var balance: Balance {
        return getBalance()
    }
    
    func getSum(from: Date, till: Date, tags: [TagViewModel] = []) -> Balance {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        request.resultType = .dictionaryResultType
        
        var predicates: [NSPredicate] = [];
        
        let datePredicate = NSPredicate(format: "valueDate >= %@ AND valueDate <= %@", from as NSDate, till as NSDate)
        predicates.append(datePredicate)
        
        if tags.count > 0 {
            let ids = tags.map { (tagModel) -> NSManagedObjectID? in
                return tagModel.objectID
            }
            let tagsPredicate = NSPredicate(format: "SUBQUERY(tags, $tag, $tag IN %@).@count == %@", argumentArray: [ids, ids.count])
            predicates.append(tagsPredicate)
            
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        
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
    
    func getMonthsList() -> [DateRange] {
        var ranges = [DateRange]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["valueDate"]

        let sort = NSSortDescriptor(key: "valueDate", ascending: false)
        request.sortDescriptors = [sort]

        let cal = Calendar(identifier: .gregorian)

        do {
            let result: [NSFetchRequestResult] = try managedContext.fetch(request)
            for item in result {
                if let itemDict = item as? Dictionary<String, Date>, let date = itemDict["valueDate"] {
                    let components = cal.dateComponents([.year, .month], from: date)
                    if let year = components.year, let month = components.month {
                        let range = DateRange(year: year, month: month)

                        let index = ranges.firstIndex { $0 == range }
                        
                        if nil == index {
                            ranges.append(range)
                        }
                    }
                }
            }
            
            return ranges
        } catch let error {
            print("Error while calculationg balance: \(error)")
            return []
        }
    }
    
    func getDaysList() -> [DateRange] {
        let cal = Calendar(identifier: .gregorian)
        let months = getMonthsList()
        var days = [DateRange]()
        
        for monthRange in months {
            let transactionInMonth = transactions(range: monthRange)
            
            for transaction in transactionInMonth {
                guard let valueDate = transaction.valueDate else { continue }
                let dayComponents = cal.dateComponents([.year, .month, .day], from: valueDate)
                guard let year = dayComponents.year, let month = dayComponents.month, let day = dayComponents.day else { continue }
                let dayRange = DateRange(year: year, month: month, day: day)
                
                let index = days.firstIndex { $0 == dayRange }
                
                if nil == index {
                    days.append(dayRange)
                }
            }
        }
        
        return days
    }
    
    func balance(range: DateRange, tags: [TagViewModel] = []) -> Balance {
        return getSum(from: range.from, till: range.till, tags: tags)
    }
    
    func transactions(range: DateRange) -> [TransactionEntity] {
        let request = TransactionEntity.allEntities()
        request.predicate = NSPredicate(format: "valueDate >= %@ AND valueDate <= %@", argumentArray: [range.from, range.till])
        
        do {
            return try managedContext.fetch(request) as [TransactionEntity]
            
        } catch let error {
            print("Error while fetching transaction for date range: \(error)")
            return []
        }
    }
    
    func tags(range: DateRange) -> [TagEntity] {
        let request = TagEntity.allEntriesFetchRequest()
        request.predicate = NSPredicate(format: "ANY transactions.valueDate >= %@ AND ANY transactions.valueDate <= %@", argumentArray: [range.from, range.till])
        
        do {
            return try managedContext.fetch(request) as [TagEntity]
        } catch let error {
            print("Error while fetching transaction for date range: \(error)")
            return []
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
        let income = getAmount(result: result, type: .income)
        let expense = getAmount(result: result, type: .expense)
        
        return Balance(
            income: Money(amount: income),
            expence: Money(amount: expense),
            from: from,
            till: till
        )
    }
    
    private func getAmount(result: [NSFetchRequestResult], type: TransactionType) -> Double {
        let typeResult = result.filter { (item) -> Bool in
            guard let dict = item as? Dictionary<String, Any> else {
                return false
            }
            
            return dict["type"] as? Int == type.rawValue
        }
        
        if typeResult.count != 1 {
            return 0
        }
        
        guard let dict = typeResult[0] as? Dictionary<String, Any> else {
            return 0
        }
        
        guard let amount = dict["balance"] as? Double else {
            return 0
        }
        
        return amount
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
        return balance(range: DateRange())        
    }
    
    func getBalanceTitle() -> String {
        String(format:"Balance: %.2f", Account.current.getBalance().total.amount)
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
            transaction.note = model.note
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
                    existingTransaction.note = model.note
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
