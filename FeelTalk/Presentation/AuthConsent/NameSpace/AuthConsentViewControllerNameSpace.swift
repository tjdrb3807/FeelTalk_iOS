//
//  AuthConsentViewControllerNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/10.
//

import Foundation

enum AuthConsentViewControllerNameSpace {
    // AuthConsentView
    /// 422.0
    static let bottomSheetViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 51.97
    
    // TitleLabel
    static let titleLabelText: String = "본인인증을 위한 약관에 동의해주세요."
    /// 20.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 30.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69
    /// 41.0
    static let titleLabelTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.04
    
    // ItemStackView
    /// 6.0
    static let itemStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.73
    /// 167.0
    static let itemStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 20.56
    /// 102.0
    static let itemStackViewheight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 12.56
    
    // NextButton
    static let nextButtonTitleLabelText: String = "다음"
    /// 18.0
    static let nextButtonTitleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 24.5
    static let nextButtonCornerRadius: CGFloat = nextbuttonHeight / 2
    /// 297.0
    static let nextButtonTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 36.57
    /// 59.0
    static let nextbuttonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26
}
