//
//  BaseView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/25.
//

import UIKit
import SnapKit

class BaseView: UIView {
    private(set) var didSetUpConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear

        self.setAttribute()
        self.setConfig()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        // Override point
    }
    
    func setConfig() {
        // Override point
    }
}
