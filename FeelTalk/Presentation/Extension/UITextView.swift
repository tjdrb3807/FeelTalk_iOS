//
//  UITextView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/24.
//

import UIKit
import RxSwift
import RxCocoa

extension UITextView {
    func updateBorderColor(isEditingBegin state: Bool) {
        state ?
        self.layer.rx.borderColor.onNext(UIColor(named: "main_500")?.cgColor) :
        self.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
    }
    
    func updateBackgroundColor(isEditingBegin state: Bool) {
        state ?
        self.rx.backgroundColor.onNext(.white) :
        self.rx.backgroundColor.onNext(UIColor(named: "gray_200"))
    }
    
    func setLineAndLetterSpacing(_ text: String) {
        let style = NSMutableParagraphStyle()
        
        style.lineSpacing = 1.25
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}
