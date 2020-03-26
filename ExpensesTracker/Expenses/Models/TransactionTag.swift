//
//  TransactionTag.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 03.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation

struct TransactionTag: Decodable, Identifiable, Equatable {
    var id: String
    var name: String
    var icon: String
    
    static func == (lhs: TransactionTag, rhs: TransactionTag) -> Bool {
        return lhs.id == rhs.id
    }
}
