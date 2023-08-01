//
//  onChangeStateChanges.swift
//  Instafilter
//
//  Created by Brandon Johns on 7/27/23.
//

//onChange updates blurAmount no matter if its the button or the slider.
// before onChange it was just a property observer that didnt update

import SwiftUI

struct onChangeStateChanges: View {
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
        .onChange(of: blurAmount) { newValue in
            print("New value is \(newValue)")
        }
    }
}

struct onChangeStateChanges_Previews: PreviewProvider {
    static var previews: some View {
        onChangeStateChanges()
    }
}
