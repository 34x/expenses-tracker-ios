//
//  TagsSettings.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 05.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI
import CoreData

struct TagsSettingsScreen: View {
    @FetchRequest(fetchRequest: TagEntity.allEntriesFetchRequest()) var tags: FetchedResults<TagEntity>
    
    var body: some View {
        let addButton = NavigationLink(
            destination: TagDetailsScreen(model: TagViewModel()),
            label: {
                Image(systemName: "plus").imageScale(.large)
        })

        return 
            List {
                ForEach(self.tags) {
                    tag -> NavigationLink<TagRow, TagDetailsScreen> in
                    
                    let model = TagViewModel(tag: tag)
                    
                    return NavigationLink(
                        destination: TagDetailsScreen(
                            model: model
                        ),
                        label: {
                            TagRow(model: model)
                    })
                    
                }
            }
            .navigationBarItems(trailing: addButton)
            .navigationBarTitle("Tags settings")
        }
    
}

struct TagsSettings_Previews: PreviewProvider {
    static var previews: some View {
        TagsSettingsScreen()
    }
}
