//
//  TestScreen.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 08.03.20.
//  Copyright © 2020 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct TestVM: Identifiable {
    var id = ""
    var name = "foo"
}

struct TestVMWrapper: Identifiable {
    var id = ""
    var name = ""
    var segment = 0
    
    init(model: TestVM) {
        id = model.id
        name = model.name
    }
    
    init() {
        id = ""
        name = ""
    }
}

struct Test2Details: View {
    @State var model: TestVMWrapper = TestVMWrapper()
    
    var body: some View {
        Form {
            Section {
                Text("name: [\(model.name)]")
                TextField("Name", text: $model.name)
            }
            
            Section {
                Text("id: [\(model.id)]")
                TextField("ID", text: $model.id)
            }
            
            Section {
                Text("id: [\(model.segment)]")
                Picker(
                    selection: $model.segment,
                    label: Text("Picker"),
                    content: {
                        Text("0").tag(0)
                        Text("1").tag(1)
                        Text("2").tag(2)
                    }
                ).pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

struct TestScreen: View {
    let items: [TestVM] = [
        TestVM(id: "0", name: "a"),
        TestVM(id: "1", name: "b"),
        TestVM(id: "2", name: "c"),
        TestVM(id: "3", name: "d"),
    ]
    var body: some View {
        NavigationView {
            List {
                ForEach(items) {
                    item -> NavigationLink<Text, Test2Details> in
                    
                    let wrapper = TestVMWrapper(model: item)
                    
                    return NavigationLink(
                        destination: Test2Details(),
                        label: {
                            Text("\(wrapper.id): \(wrapper.name)")
                        }
                    )
                }
            }
        }
    }
}

struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}
