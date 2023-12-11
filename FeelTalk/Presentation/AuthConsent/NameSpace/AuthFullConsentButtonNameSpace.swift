//
//  AuthFullConsentButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/01.
//

import Foundation

enum AuthFullConsentButtonNameSpace {
    // AuthFullConsentButton
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26                    // 1.0
    static let cornerRadius: CGFloat = 16.0
    static let topInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 11.20                        // 91.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.88                           // 64.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2         // 12.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46         // 20.0
    static let contentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2    // 12.0
    static let contentStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2   // 12.0
    static let contentStackViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator *  2.46     // 20.0
    
    // CheckIcon
    static let checkIconSelectedImage: String = "icon_circle_check_able"
    static let checkIconUnSelectedImage: String = "icon_circle_check_unable"
    
    // ContentLabel
    static let contentLabelText: String = "전체 동의하기"
    static let contentLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26           // 16.0
}
