//
//  ToastMessageNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/21.
//

import Foundation

enum ToastMessageNameSpace {
    // ContentView
    static let contentViewBackgroundColorAlpha: CGFloat = 0.7
    static let contentViewCornerRadius: CGFloat = 16.0
    static let contentViewShadowColorAlpha: CGFloat = 0.16
    static let contentViewShadowOpacity: Float = 1.0
    static let contentViewShadowOffsetWidth: CGFloat = 0.0
    static let contentViewShadowOffsetHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49            // 4.0
    static let contentViewShadowRadius: CGFloat = 10.0
    static let contentViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                 // 12.0
    static let contentViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                // 12.0
    static let contentViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89                        // 56.0
    static let contentViewRequestAnswerTypeTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 80.78    // 656.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66                // 10.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97                 // 16.0
    static let contentStackViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97              // 16.0
    
    // MessageLabel
    static let messageLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26                   // 16.0
    
    // RequestAnswerButton
    static let requestAnswerButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8               // 48.0
    static let requestAnswerButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58                // 21.0
    static let requestAnswerButtonTitleText: String = "콕찌르기"
    static let requestAnswerButtonTextColorRed: CGFloat = 1.0
    static let requestAnswerButtonTextColorGreen: CGFloat = 0.89
    static let requestAnswerButtonTextColorBlue: CGFloat = 0.33
    static let requestAnswerButtonTextColorAlpha: CGFloat = 1.0
    static let requestAnswerButtonTitleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73  // 14.0
    static let requestAnswerButtonBorderWidth: CGFloat = 1.0
}
