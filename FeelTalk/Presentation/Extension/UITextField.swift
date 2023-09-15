//
//  UITextField.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/23.
//

import UIKit
import RxSwift
import RxCocoa

extension UITextField {
    func updateBorderColor(isEditingBegin state: Bool) {
        state ?
        self.layer.rx.borderColor.onNext(UIColor(named: "main_500")?.cgColor) :
        self.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
    }
    
    func updateBackgourndColor(isEditingBegin state: Bool) {
        state ?
        self.rx.backgroundColor.onNext(.white) :
        self.rx.backgroundColor.onNext(UIColor(named: "gray_200"))
    }
    
    func setPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text,
                                                        attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
