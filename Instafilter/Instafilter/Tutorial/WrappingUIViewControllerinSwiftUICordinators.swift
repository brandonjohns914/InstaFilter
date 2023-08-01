//
//  WrappingUIViewControllerinSwiftUI.swift
//  Instafilter
//
//  Created by Brandon Johns on 7/31/23.
//

import SwiftUI

struct WrappingUIViewControllerinSwiftUI: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button("Select Image") {
                showingImagePicker = true
            }
            Button("Save Image") {
                guard let inputImage = inputImage else {return }
               let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: inputImage)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage()
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        
        image = Image(uiImage: inputImage)
        
        
    }
}

struct WrappingUIViewControllerinSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        WrappingUIViewControllerinSwiftUI()
    }
}
