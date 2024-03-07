//
//  LockNumberHintViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/12.
//

import Foundation

enum LockNumberHintViewNameSpace {
    // MARK: NavigationBar
    /// "암호설정"
    static let navigationBarSettingsTypeTitleText: String = "암호설정"
    /// "암호재설정"
    static let navigationBarResetTypeTitleText: String = "암호재설정"
    // MARK: ScrollStackView
    /// 32.0
    static let scrollStackViewSettingsTypeSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.94
    /// 52.0
    static let scrollStackViewResetTypeSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.40
    
    // MARK: ContentStackView
    /// 24.0
    static let contentStakcViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    
    // MARK: ConfirmButton
    /// "확인"
    static let confirmButtonTitleText: String = "확인"
    /// 18.0
    static let confirmButtonTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 29.5
    static let confirmButtonCornerRadius: CGFloat = confirmButtonHeight / 2
    /// 59.0
    static let confirmButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26
    
    // MARK: BottomSpacing
    /// 4.0
    static let bottomSpacingHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
}
