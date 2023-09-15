//
//  UIScrollView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/25.
//

import UIKit

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
}
