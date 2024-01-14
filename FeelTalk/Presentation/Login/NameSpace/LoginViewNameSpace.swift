//
//  LoginViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import UIKit

enum LoginViewNameSpace {
    // LoginView
    static let loginViewBackgroundColor: String = "gray_100"
    
    // LoginButtonStackView
    static let loginButtonStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98      // 8.0
    static let loginButtonStackViewTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 21.30   // 173.0
    
    // InquiryButton
    /// 39.0
    static let inquiryButtonTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.80
}
