//
//  ImageSaver.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/20.
//

import Foundation
import UIKit

// https://www.hackingwithswift.com/books/ios-swiftui/how-to-save-images-to-the-users-photo-library
class ImageSaver: NSObject {
    
    private var onComplete: () -> Void
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            onComplete()
        }
    }
}
