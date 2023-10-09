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
    
    func setClearButton(with image: UIImage, mode: UITextField.ViewMode) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66  // 10.0
        stackView.backgroundColor = .clear
        
        let leadingSpacingView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0,
                                                                                  height: 0)))
        leadingSpacingView.backgroundColor = .clear
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(origin: .zero,
                                   size: CGSize(width: CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33, // 20.0
                                                height: CommonConstraintNameSpace.verticalRatioCalculator * 2.46))  // 20.0
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        
        let trailingSpacingView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53, // 2.0
                                                                                   height: 0)))
        trailingSpacingView.backgroundColor = .clear
        
        [leadingSpacingView, clearButton, trailingSpacingView].forEach { stackView.addArrangedSubview($0) }
        
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingDidBegin)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingChanged)
        
        self.rightView = stackView
        self.rightViewMode = mode
    }
    
    @objc
    private func displayClearButtonIfNeeded() {
        self.rightView?.isHidden = (self.text?.isEmpty) ?? true
    }
    
    @objc
    private func clear(sender: AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
    
    
}
