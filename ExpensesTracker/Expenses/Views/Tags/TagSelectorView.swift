//
//  TagSelectorView.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 03.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI
import CoreData

struct TagSelectorView: View {
    @FetchRequest(fetchRequest: TagEntity.allEntriesFetchRequest()) var tags: FetchedResults<TagEntity>
    
    @State var selectedTags: [TagViewModel]
    
    var onChange: ((_ selected: [TagViewModel]) -> Void)
    
    var body: some View {
        List {
            ForEach(self.tags) {
                tag -> Button<TagRow> in
                
                let model = TagViewModel(tag: tag)
                
                return Button(action: {
                    self.toggleTag(model: model)
                    
                }, label: {
                    TagRow(model: model, selected: self.isTagSelected(tagView: model))
                })
            }
        }.navigationBarTitle("Select tags")
    }
    
    private func toggleTag(model: TagViewModel) {
        let index = self.selectedTags.firstIndex(of: model)
        
        if let index = index {
            self.selectedTags.remove(at: index)
        } else {
            self.selectedTags.append(model)
        }
        
        self.onChange(self.selectedTags)
    }
    
    func isTagSelected(tagView: TagViewModel) -> Bool {
        for selectedTag in selectedTags {
            if selectedTag == tagView {
                return true
            }
        }
        return false
    }
    
}

struct TagSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TagSelectorView(selectedTags: [], onChange: {_ in })
            TagSelectorView(selectedTags: [
                TagViewModel(name: "Music", icon: "🎹"),
                TagViewModel(name: "Other", icon: "🦄")
            ], onChange: {_ in })
        }.previewLayout(.fixed(width: 400, height: 92))
    }
}
