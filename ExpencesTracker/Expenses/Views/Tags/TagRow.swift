//
//  TagRow.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 05.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TagRow: View {
    var model: TagViewModel
    var selected: Bool = false
    var showBalance: Bool = false
    var dateRange: DateRange?

    var body: some View {
        let balance: Balance = Account.current.balance(range: dateRange ?? DateRange(), tags: [model])
        let theme = Theme()
        
        return HStack {
            Text(model.icon)
                .font(.largeTitle)
                .frame(width: 64)
                .foregroundColor(Color(UIColor.label))
            Text(model.name)
        
            Spacer()
            showBalance ? Text(balance.total.string)
                .foregroundColor(theme.balanceColor(balance: balance)) : nil
            
            selected ? Text("✓").font(.title) : nil
        }
    }
}

struct TagRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TagRow(model: TagViewModel(name: "Eating out", icon: "🍱"))
            TagRow(
                model: TagViewModel(name: "Public transport", icon: "🚎"),
                selected: true
            )
        }.previewLayout(.fixed(width: 400, height: 80))
    }
}
