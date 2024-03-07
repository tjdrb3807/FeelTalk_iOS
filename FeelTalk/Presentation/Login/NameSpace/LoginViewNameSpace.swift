//
//  LoginViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import UIKit

enum LoginViewNameSpace {
    // MARK: LoginView
    static let loginViewBackgroundColor: String = "gray_100"
    
    // MARK: LoginButtonStackView
    static let loginButtonStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98      // 8.0
    static let loginButtonStackViewTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 21.30   // 173.0
    
    // MARK: InquiryButton
    /// 39.0
    static let inquiryButtonTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.80
    /// "문의사항이 있으신가요?"
    static let inquiryButtonTitleText: String = "문의사항이 있으신가요?"
    /// 21.0
    static let inquiryButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
}
