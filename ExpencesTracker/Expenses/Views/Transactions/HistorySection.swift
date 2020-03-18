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
    var body: some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
            
        let tags = Account.current.tags(range: range)
        let balance = Account.current.balance(range: range)
        
        return Section(
            header: HStack {
                Text(formatter.string(from: range.from))
                Spacer()
                Text(balance.total.string)
            },
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
