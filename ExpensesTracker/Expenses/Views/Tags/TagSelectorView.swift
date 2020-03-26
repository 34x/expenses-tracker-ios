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
    
    var availableTags: [TagViewModel] {
        return Account.current.tags.map {
            (tag) -> TagViewModel in
            
            return TagViewModel(tag: tag)
        }
    }
    
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
    
    var stack: some View {
        HStack {
            ForEach(availableTags) {
                self.getStackItem($0)
            }
        }
    }
    
    func getStackItem(_ tagView: TagViewModel) -> some View {
        
        return Button(
            action: {

                var newSelectedTags: [TagViewModel] = []
                
                for tv in self.availableTags {
                    if tv == tagView {
                        if !self.isTagSelected(tagView: tv) {
                            newSelectedTags.append(tv)
                        }
                    }
                    
                    if self.isTagSelected(tagView: tv) && tv != tagView {
                        newSelectedTags.append(tv)
                    }
                }
                
//                self.onChange?(newSelectedTags)
                
            },
            label: {
                TagItemView(
                    viewModel: tagView,
                    selected: isTagSelected(tagView: tagView)
                )
        })
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
                TagViewModel(tag: tagData[1]),
                TagViewModel(tag: tagData[3])
            ], onChange: {_ in })
        }.previewLayout(.fixed(width: 400, height: 92))
    }
}
