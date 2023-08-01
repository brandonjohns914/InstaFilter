//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Brandon Johns on 7/31/23.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    
    var successHandler: (() -> Void)?
    
    var errorHandler: ((Error) -> Void)?
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}
