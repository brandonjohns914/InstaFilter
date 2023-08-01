//
//  IntegratingCoreImage.swift
//  Instafilter
//
//  Created by Brandon Johns on 7/27/23.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct IntegratingCoreImage: View {
    
    @State private var image: Image?
    
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadUIImage)
        
    }
    
    func loadImage() {
        image = Image("Example")
    }
    
    func loadUIImage() {
        guard let inputImage = UIImage(named: "Example") else {
            return
        }
        
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        //let currentFilter = CIFilter.sepiaTone()
        //let currentFilter = CIFilter.pixellate()
        //let currentFilter = CIFilter.twirlDistortion()
        let currentFilter = CIFilter.crystallize()
        currentFilter.inputImage = beginImage

        let amount = 1.0

        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey) }
        
        
        //sepia
        //currentFilter.intensity = 1
        //currentFilter.scale = 100
  
        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2 )

        //read out CIImage
        guard let outputImage = currentFilter.outputImage else {return }
        
        if let cgimage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimage)
            image = Image(uiImage: uiImage)
        }
        
        
    }
}

struct IntegratingCoreImage_Previews: PreviewProvider {
    static var previews: some View {
        IntegratingCoreImage()
    }
}
