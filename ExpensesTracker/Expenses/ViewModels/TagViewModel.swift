//
//  CategoryViewModel.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 02.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

struct TagViewModel: Equatable, Identifiable {
    var id: String
    var objectID: NSManagedObjectID?
    var path: String
    var name: String
    var icon: String
    var note: String
    var type: TransactionType
    
    var isDraft: Bool {
        return "" == path
    }
    
    init() {
        self.init(id: "", path: "", name: "", icon: "", note: "", type: .expense)
    }
    
    init (tag: TransactionTag) {
        self.init(id: tag.id, path: tag.id, name: tag.name, icon: tag.icon, note: "", type: .expense)
    }
    
    init(tag: TagEntity) {
        self.id = tag.objectID.uriRepresentation().absoluteString
        self.name = tag.name ?? ""
        self.icon = tag.icon ?? ""
        self.note = tag.note ?? ""
        self.type = TransactionType(rawValue: Int(tag.type))!
        self.path = tag.objectID.uriRepresentation().absoluteString
        self.objectID = tag.objectID
    }
    
    init(name: String, icon: String) {
        self.init(id: "", path: "", name: name, icon: icon, note: "", type: .expense)
    }
    
    init(name: String, icon: String, note: String, type: TransactionType) {
        self.init(id: "", path: "", name: name, icon: icon, note: note, type: type)
    }
    
    init(id: String, path: String, name: String, icon: String, note: String, type: TransactionType) {
        self.id = id
        self.name = name
        self.icon = icon
        self.note = note
        self.type = type
        self.path = path
    }
}
