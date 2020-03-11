//
//  TagItemsView.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 03.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TagItemsView: View {
    var tags: [TagViewModel]
    
    var body: some View {
        HStack {
            ForEach(tags) {
                Text($0.icon)
                    .font(.title)
            }
        }
    }
}

struct TagItemsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TagItemsView(tags: [TagViewModel(tag: tagData[5])])
            TagItemsView(tags: [
                TagViewModel(tag: tagData[0]),
                TagViewModel(tag: tagData[1])
            ])
        }.previewLayout(.fixed(width: 92, height: 92))
    }
}
