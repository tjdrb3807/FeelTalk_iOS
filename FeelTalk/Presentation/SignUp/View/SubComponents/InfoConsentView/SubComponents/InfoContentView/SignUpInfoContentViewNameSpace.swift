//
//  SignUpInfoContentViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/24.
//

import Foundation

enum SignUpInfoContentViewNameSpace {
    // SignUpInfoContentView
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.13                    // 8.0
    
    // SpacingView
    static let SpacingViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06           // 4.0
    
    // CheckButton
    static let checkButtonNormalImage: String = "icon_check_unselected"
    static let checkButtonSelectedImage: String = "icon_check_selected"
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53    // 2.0
    
    // OptionLabel
    static let OptionLabelEssentialText: String = "[필수]"
    static let OptionLabelChoiceText: String = "[선택]"
    static let OptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73        // 14.0
    
    // ContentLabel
    static let contentLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73       // 14.0
    //
}
