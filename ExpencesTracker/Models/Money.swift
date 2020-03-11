//
//  Money.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 07.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation

struct Money {
    var amount: Double
    var string: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(for: amount) ?? ""
    }
}
