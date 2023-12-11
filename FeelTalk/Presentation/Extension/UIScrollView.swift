//
//  UIScrollView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/25.
//

import UIKit

public enum AdultAuthViewScrollDirection {
    case nameInputView
    case idCardNumberInputview
    case phoneInfoInputView
    case consentView
    case authNumberInfoView
}

extension UIScrollView {
    func scrollToTop() {
        setContentOffset(.zero, animated: true)
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0.0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
}

extension UIScrollView {
    func scroll(to direction: AdultAuthViewScrollDirection) {
        DispatchQueue.main.async {
            switch direction {
                
            case .nameInputView:
                self.scrollToTop()
            case .idCardNumberInputview:
                self.scrollToIDCardNumberInputView()
            case .phoneInfoInputView:
                break
            case .consentView:
                break
            case .authNumberInfoView:
                self.scrollToBottom()
            }
        }
    }
    
    private func scrollToIDCardNumberInputView() {
        let topOffset = CGPoint(x: .zero,
                                y: contentSize.height - 68)
        if topOffset.y > 0.0 {
            setContentOffset(topOffset, animated: true)
        }
    }
    
    
}
