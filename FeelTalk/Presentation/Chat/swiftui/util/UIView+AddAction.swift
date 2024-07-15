//
//  UIView#AddAction.swift
//  FeelTalk
//
//  Created by 유승준 on 2024/07/14.
//

import Foundation
import UIKit

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}
