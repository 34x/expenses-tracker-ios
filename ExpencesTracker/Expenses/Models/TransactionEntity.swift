//
//  TransactionEntity.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 04.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation

import CoreData

extension TransactionEntity: Identifiable {
    static func allEntities() -> NSFetchRequest<TransactionEntity> {
        
        let request: NSFetchRequest<TransactionEntity> = NSFetchRequest(entityName: "TransactionEntity")
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "valueDate", ascending: false)]
          
        return request
    }
    
    static func allEntitiesGrouped() -> NSFetchRequest<NSDictionary> {
        
        let request: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "TransactionEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "valueDate", ascending: false)]
        request.propertiesToGroupBy = ["valueDate"]
        request.propertiesToFetch = ["valueDate"]
        request.resultType = .dictionaryResultType
        return request
    }
}
