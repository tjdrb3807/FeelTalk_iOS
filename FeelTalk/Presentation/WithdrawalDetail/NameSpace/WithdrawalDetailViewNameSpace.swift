//
//  WithdrawalDetailViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum WithdrawalDetailViewNameSpace {
    // MARK: ContentStackView
    /// 32.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.94
    
    // MARK: WithdrawalButton
    /// "탈퇴하기"
    static let withdrawalButtonTitleText: String = "탈퇴하기"
    /// 28.5
    static let withdrawalButtonCornerRadius: CGFloat = withdrawalButtonHeight / 2
    /// 1.0
    static let withdrawalButtonBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26
    /// 59.0
    static let withdrawalButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26
    /// 18,0
    static let withdrawalButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    
    // MARK: BottomSpacing
    /// 42.0
    static let bottomSpacingHeight: CGFloat = WithdrawalDetailDescriptionViewNameSpace.height - contentStackViewSpacing
}
