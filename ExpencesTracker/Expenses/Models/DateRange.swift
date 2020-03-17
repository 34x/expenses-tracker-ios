//
//  DateRange.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 17.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation

struct DateRange: Equatable, Identifiable {
    var id: String {
        return String("\(from)-\(till)")
    }
    
    var from: Date
    var till: Date
    
    init(year: Int, month: Int) {
        let cal = Calendar(identifier: .gregorian)
        
        var componentsFrom = DateComponents()
        componentsFrom.year = year
        componentsFrom.month = month
        componentsFrom.day = 1
        
        from = cal.date(from: componentsFrom) ?? Date()
        
        till = cal.date(byAdding: DateComponents(month: 1, day: -1), to: from) ?? Date()
    }
    
    static func == (lhs: DateRange, rhs: DateRange) -> Bool {
        return lhs.from == rhs.from && lhs.till == rhs.till
    }
}
