//
//  Money.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 07.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import Foundation

struct Money {
    var amount: Double = 0.0
    var amountUnsigned: Double {
        return abs(amount)
    }
}
