//
//  PropertyWrappersBecomeStructs.swift
//  Instafilter
//
//  Created by Brandon Johns on 7/27/23.
//

import SwiftUI

struct PropertyWrappersBecomeStructs: View {
    
    @State private var blurAmount = 0.0
    
    var body: some View {
        VStack {
            Text("Brandon")
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
            
            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20)
            }
        }
    }
}

struct PropertyWrappersBecomeStructs_Previews: PreviewProvider {
    static var previews: some View {
        PropertyWrappersBecomeStructs()
    }
}
