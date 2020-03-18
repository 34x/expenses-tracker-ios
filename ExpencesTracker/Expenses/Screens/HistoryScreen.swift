//
//  HistoryScreen.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 18.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct HistoryScreen: View {
    var body: some View {
        let months = Account.current.getMonthsList()
        
        return NavigationView {
            List {
                ForEach(months) {
                    range -> HistorySection in
                    HistorySection(range: range)
                }
            }
        }
    }
}

struct HistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
    }
}
