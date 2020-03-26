//
//  TagEntity.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 05.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation
import CoreData

extension TagEntity: Identifiable {
    static func allEntriesFetchRequest() -> NSFetchRequest<TagEntity> {
        let request: NSFetchRequest<TagEntity> = NSFetchRequest(entityName: "TagEntity")
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
          
        return request
    }
}
