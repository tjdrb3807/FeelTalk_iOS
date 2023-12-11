//
//  AdultAuthConsentButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/05.
//

import Foundation

enum AdultAuthConsentButtonNameSpace {
    // AdultAuthConsentButton
    /// 1.0
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26
    /// 12.0
    static let cornerRadius: CGFloat = 12.0
    /// 64.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.88
    
    // ContentStackView
    /// 12.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 20.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46
    /// 12.0
    static let contentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 12.0
    static let contentStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 20.0
    static let contentStackViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46
    
    // CheckIcon
    static let checkIconActiveImage: String = "icon_circle_check_able"
    static let checkIconNonActiveImage: String = "icon_circle_check_unable"
    
    // ContentLabel
    static let contentLabelText: String = "본인인증 이용약관에 동의합니다."
    /// 16.0
    static let contentLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    
    // RightArrowIcon
    static let rightArrowIconImage: String = "icon_right_arrow_gray"
}
