//
//  UIImage+FixOrientation.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/21.
//

import Foundation
import UIKit

// https://stackoverflow.com/a/59818090/25162070
extension UIImage {
    func makeFixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return normalizedImage;
    }
}
