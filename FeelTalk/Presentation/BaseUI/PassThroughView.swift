//
//  PassThroughView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/25.
//

import Foundation
import UIKit

class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        return hitView == self ? nil : hitView
    }
}
