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
    var showNames = false
    
    var body: some View {
        HStack {
            ForEach(tags) {
                TagItemView(viewModel: $0)
            }
        }
    }
}

struct TagItemsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TagItemsView(tags: [
                TagViewModel(name: "Education", icon: "🎓")
            ])
            TagItemsView(tags: [
                TagViewModel(name: "Education", icon: "🎓"),
                TagViewModel(name: "Games", icon: "👾")
            ])
        }.previewLayout(.fixed(width: 92, height: 92))
    }
}
