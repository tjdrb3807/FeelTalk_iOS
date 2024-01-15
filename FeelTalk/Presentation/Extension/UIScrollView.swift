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
        let bottomOffset = CGPoint(x: 0.0, y: contentSize.height - bounds.height)
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

// MARK: AdultAuthView Scroll
extension UIScrollView {
    func scroll(to direction: AdultAuthViewScrollDirection) {
        DispatchQueue.main.async {
            switch direction {
                
            case .nameInputView:
                self.scrollToTop()
            case .idCardNumberInputview:
                self.scrollToIDCardNumberInputView()
            case .phoneInfoInputView:
                self.scrollToPhoneNumberInputView()
            case .consentView:
                break
            case .authNumberInfoView:
                self.secrollToAuthNumberInputView()
            }
        }
    }
    
    private func scrollToIDCardNumberInputView() {
        let topOffset = CGPoint(x: .zero,
                                y: CommonConstraintNameSpace.verticalRatioCalculator * 8.37) // 68.0
        if topOffset.y > 0.0 {
            setContentOffset(topOffset, animated: true)
        }
    }
    
    private func scrollToPhoneNumberInputView() {
        let topOffset = CGPoint(x: .zero,
                                y: CommonConstraintNameSpace.verticalRatioCalculator * 16.74)   // 136
        
        if topOffset.y > 0.0 {
            setContentOffset(topOffset, animated: true)
        }
    }
    
    private func secrollToAuthNumberInputView() {
        let topOffset = CGPoint(x: .zero,
                                y: CommonConstraintNameSpace.verticalRatioCalculator * 34.48)   // 280.0
        
        if topOffset.y > 0.0 {
            setContentOffset(topOffset, animated: true)
        }
    }
}

// MARK: ChallengeDetailView Scroll
extension UIScrollView {
    func scroll(to direction: ChallengeDetailViewInputType) {
        switch direction {
        case .title:
            scrollToTop()
        case .deadline:
            break
        case .content:
            scrollToBottom()
        }
    }

}
