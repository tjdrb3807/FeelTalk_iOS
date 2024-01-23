//
//  String.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/22.
//

import UIKit

extension String {
    
    /// UITextView의 동적인 높이를 결정하는 함수
    /// - Parameter font: UITextView에 설정된 Font
    /// - Returns: font 기반으로 환산된 CGRect
    func getEstimatedFrame(with font: UIFont) -> CGRect {
//        let size = CGSize(width: (UIScreen.main.bounds.width) * (2 / 3), height: 1000.0)
        let size = CGSize(width: (UIScreen.main.bounds.width), height: 1000.0)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: options, attributes: [.font: font], context: nil)
        
        return estimatedFrame
    }
    
    /// String type date 의 문자열에서 'T' 를 공백으로 변경하는 함수
    static func replaceT(_ str: String) -> String {
        let str = str.replacingOccurrences(of: "T", with: " ")
        
        return str
    }
}
