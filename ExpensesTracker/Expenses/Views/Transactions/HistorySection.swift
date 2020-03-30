//
//  HistorySection.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 18.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct HistorySection: View {
    var range: DateRange
    @EnvironmentObject var moneyFormatter: MoneyFormatter
    @EnvironmentObject var dateFormatter: ExpensesDateFormatter
    @EnvironmentObject var account: Account
    
    var body: some View {
        let tags = account.tags(range: range)
        let balance = account.balance(range: range)
        let theme = Theme()
        
        return Section(
            header: HStack {
                Text(dateFormatter.string(range.from, type: .HistorySection))
                Spacer()
                Text(moneyFormatter.string(balance.total))
                    .foregroundColor(theme.balanceColor(balance: balance))
            }.font(.headline),
            content: {
                ForEach(tags) {
                    tag -> TagRow in
                    TagRow(
                        model: TagViewModel(tag: tag),
                        selected: false,
                        showBalance: true,
                        dateRange: self.range
                    )
                }
        })
    }
}

struct HistorySection_Previews: PreviewProvider {
    static var previews: some View {
        HistorySection(range: DateRange(year: 2020, month: 03))
    }
}
