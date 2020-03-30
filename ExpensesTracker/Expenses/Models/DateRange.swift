//
//  DateRange.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 17.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation

enum DateRangeType {
    case allBeforeNow
}

struct DateRange: Equatable, Identifiable {
    var id: String {
        return String("\(from)-\(till)")
    }
    
    var from: Date
    var till: Date
    
    /// - returns: current month range
    init() {
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        
        let components = cal.dateComponents([.year, .month], from: now)
                
        self.init(year: components.year!, month: components.month!)
    }
    
    /// - returns: specific month range
    init(year: Int, month: Int) {
        let cal = Calendar(identifier: .gregorian)
        
        var componentsFrom = DateComponents()
        componentsFrom.year = year
        componentsFrom.month = month
        componentsFrom.day = 1
        
        from = cal.date(from: componentsFrom) ?? Date()
        
        till = cal.date(byAdding: DateComponents(month: 1, second: -1), to: from) ?? Date()
    }
    
    init(type: DateRangeType) {
        switch type {
        case .allBeforeNow:
            self.till = Date()
            self.from = Date(timeIntervalSince1970: 0)
        }
    }
    
    /// - returns: specific day range
    init(year: Int, month: Int, day: Int) {
        let cal = Calendar(identifier: .gregorian)
        
        var componentsFrom = DateComponents()
        componentsFrom.year = year
        componentsFrom.month = month
        componentsFrom.day = day
        
        from = cal.date(from: componentsFrom) ?? Date()
        
        till = cal.date(byAdding: DateComponents(day: 1, second: -1), to: from) ?? Date()
    }
    
    static func == (lhs: DateRange, rhs: DateRange) -> Bool {
        return lhs.from == rhs.from && lhs.till == rhs.till
    }
}
