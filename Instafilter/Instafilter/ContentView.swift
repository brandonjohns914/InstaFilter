//
//  ContentView.swift
//  Instafilter
//
//  Created by Brandon Johns on 7/27/23.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 5.0
    @State private var filterScale = 5.0
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    
    @State private var showingFilterSheet = false
    
    @State private var processedImage: UIImage?
    
    @State private var showingSaveError = false
    let context = CIContext()
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                    HStack {
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                            .onChange(of: filterIntensity) {_ in applyProcessing() }
                        
                    }
                    .padding(.vertical)
                }
                if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                    HStack {
                        Text("Radius")
                        Slider(value: $filterRadius, in: 0...200)
                            .onChange(of: filterRadius) {_ in applyProcessing() }
                        
                    }
                    .padding(.vertical)
                }
                if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                    HStack {
                        Text("Scale")
                        Slider(value: $filterScale, in: 0...10)
                            .onChange(of: filterScale) {_ in applyProcessing() }
                        
                    }
                    .padding(.vertical)
                }
                
                HStack {
                    Button("Change Filter"){
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(inputImage == nil)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage ) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select the filter", isPresented: $showingFilterSheet) {
                Group {
                    Button("Bloom") { setFilter(CIFilter.bloom()) }
                    
                    Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                    
                    Button("Edges") { setFilter(CIFilter.edges()) }
                    
                    Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                    
                    Button("Noir") { setFilter(CIFilter.photoEffectNoir())}
                    
                    Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                    
                    Button("Pointillize") { setFilter(CIFilter.pointillize()) }
                    
                    Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                    
                    Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                    
                    Button("Vignette") { setFilter(CIFilter.vignette()) }
                }
                Group {
                    
                    Button("Cancel", role: .cancel) { }
                }
            }
            .alert("Oops!", isPresented: $showingSaveError){
                Button("OK") {}
            } message: {
                Text("Sorry, there was an error saving your Image - please check you have allowed permission for this app to save photos.")
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func save() {
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()

        imageSaver.successHandler = {
            print("Success")
        }
        
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }

        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func applyProcessing(){
        
        let inputKeys = currentFilter.inputKeys
       
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey) }
        
       
        
        guard let outputImage = currentFilter.outputImage else {return}
        
        if let cgimage = context.createCGImage(outputImage, from: outputImage.extent)
        {
            let uiImage = UIImage(cgImage: cgimage)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
            
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
