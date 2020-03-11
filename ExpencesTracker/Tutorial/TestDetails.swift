//
//  TestDetails.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 02.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TestDetails: View {
    var onDismiss: () -> Void
    
    var body: some View {
        Group {
            Text("Hello!")
            Button(action: {
                self.onDismiss()
            }) {
                Text("Go back!")
            }
        }
        
    }
}

struct TestDetails_Previews: PreviewProvider {
    static var previews: some View {
        TestDetails(onDismiss: {})
    }
}
