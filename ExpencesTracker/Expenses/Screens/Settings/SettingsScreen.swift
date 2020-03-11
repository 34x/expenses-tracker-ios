//
//  SettingsScreen.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 09.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        
        return NavigationView {
            List {
                Section {
                    NavigationLink(
                        destination: TagsSettingsScreen(),
                        label: {
                            Text("Tags")
                    })
                }
                Section(
                    header: Text("App version"),
                    content: {
                        Text("Version: \(appVersion), build: \(buildNumber)")
                })
                
            }.navigationBarTitle("Settings")
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
