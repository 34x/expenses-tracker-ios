//
//  BalanceLabel.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 01.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct BalanceLabel: View {
    @State private var balance: String = "Balance: loading"
    
    var body: some View {
        Text(
            Account.current.getBalanceTitle())
            .font(.title)
    }
}

struct BalanceLabel_Previews: PreviewProvider {
    static var previews: some View {
        BalanceLabel()
    }
}
