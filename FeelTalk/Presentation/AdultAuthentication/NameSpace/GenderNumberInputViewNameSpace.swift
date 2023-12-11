//
//  GenderNumberInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/07.
//

import Foundation

enum GenderNumberInputViewNameSpace {
    // GenderNumberInputView
    /// 152.0
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 40.53
    /// 56.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
    
    // DotIcon
    static let dotIconImage: String = "icon_dot_gray"
    /// 16.0
    static let dotIconTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 17.0
    static let dotIconLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.53
    /// 16.0
    static let dotIconBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 16.0
    static let dotIconWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    
    // GenderNmberInputTextField
    /// 16.0
    static let genderNumberInputTextFieldTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 3.0
    static let genderNumberInputTextFieldPaddingViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.8
    /// 16.0
    static let genderNumberInputTextFieldTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 17.0
    static let genderNumberInputTextFieldLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.53
    /// 16.0
    static let genderNumberInputTextFieldBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 16.0
    static let genderNumberInputTextFieldWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 1
    static let genderNumberInputTextFieldMaxTextCount: Int = 1
    
    // AsteriskIconStackView
    /// 7.0
    static let asteriskIconStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.86
    /// 16.0
    static let asteriskIconStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 40.0
    static let asteriskIconStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 10.66
    /// 17.0
    static let asteriskIconStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.53
    /// 16.0
    static let asteriskIconStackViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    
    // AsteriskIcon
    /// 6
    static let asteriskIconCount: Int = 6
    static let asteriskIconImage: String = "icon_asterisk_gray"
    
}
