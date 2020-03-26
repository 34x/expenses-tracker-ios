//
//  ContentView.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 30.11.19.
//  Copyright © 2019 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct LandmarkDetail: View {
    var body: some View {
        VStack(alignment: .leading) {
            MapView()
                .frame(height: 200)
                .edgesIgnoringSafeArea(.top)
            
            HStack() {
                Spacer()
                CircleImage()
                Spacer()
            }
            .offset(y: -150)
            .padding(.bottom, -150)
            
            VStack(alignment: .leading) {
                Text("Title").font(.title)
                HStack() {
                    Text("Hello, World!").font(.subheadline)
                    Spacer()
                    Text("Something else")
                }
            }.padding()
            
            Spacer()
        }
    }
}

struct LandmarkDetail_Preview: PreviewProvider {
    static var previews: some View {
        LandmarkDetail()
    }
}
