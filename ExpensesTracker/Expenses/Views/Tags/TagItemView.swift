//
//  CategoryItemView.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 02.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TagItemView: View {
    var viewModel: TagViewModel
    var selected: Bool = false
    
    var body: some View {
        let stack = HStack {
            Text(viewModel.icon)
                .font(.title)
                .frame(width: 32)
            Text(viewModel.name)
                .frame(alignment: .center)
        }
        .foregroundColor(selected ? .red : nil)
        .blur(radius: selected ? 2 : 0)
        
        
        return stack
    }
}

struct CategoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TagItemView(viewModel: TagViewModel(tag: tagData[2]))
            TagItemView(viewModel: TagViewModel(tag: tagData[2]), selected: true)
        }.previewLayout(.fixed(width: 300, height: 92))
    }
}
