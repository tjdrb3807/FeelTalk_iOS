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
}
