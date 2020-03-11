//
//  TestList.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 03.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TestList: View {
    var body: some View {
        List(Account.current.transactions) {_ in 
            Section {
                Text("Header")
            }
        }
    }
}

struct TestList_Previews: PreviewProvider {
    static var previews: some View {
        TestList()
    }
}
