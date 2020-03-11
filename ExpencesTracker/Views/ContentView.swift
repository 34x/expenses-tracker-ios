//
//  ContentView.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 01.12.19.
//  Copyright © 2019 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
//            TestScreen().tabItem {
//                Text("Test")
//            }
            
            CreateTransactionScreen().tabItem {
                Image(systemName: "house")
                Text("Create")
            }
            
            TransactionsListScreen().tabItem {
                Image(systemName: "arrow.right.arrow.left")
                Text("Transactions")
            }
            
            SettingsScreen().tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
