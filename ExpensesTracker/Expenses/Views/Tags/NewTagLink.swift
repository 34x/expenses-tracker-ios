//
//  NewTagLink.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 07.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct NewTagLink: View {
    var body: some View {
        NavigationLink(
            destination: TagDetails(model: TagViewModel()),
            label: {
                Text("New tag")
            }
        )
    }
}

struct NewTagLink_Previews: PreviewProvider {
    static var previews: some View {
        NewTagLink()
    }
}
