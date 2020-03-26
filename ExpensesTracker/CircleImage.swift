//
//  CircleImage.swift
//  ExpencesTracker
//
//  Created by Maksim Tuzhilin on 30.11.19.
//  Copyright © 2019 Maksim Tuzhilin. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("911_cockpit")
        
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(
                    Color.white,
                    lineWidth: 10)
            )
            .shadow(radius: 10)
//            .scaleEffect(0.1)
            
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
