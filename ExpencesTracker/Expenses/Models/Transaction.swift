//
//  Transaction.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 28.02.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation



enum TransactionType: Int, Decodable {
    case income = 1
    case expense = 2
    case unknown = 0
}

struct Transaction: Decodable, Identifiable {
    var id: String = "new"
    var amount: Double?
    var tags: [String] = []
    
    var date: Date?
    
    var type: TransactionType
        
    var isDraft: Bool {
        return id == "new"
    }
    
    init(type: TransactionType) {
        self.type = type
    }
}
