//
//  ChallengeContentViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/14.
//

import Foundation

enum ChallengeContentViewNameSpace {
    // MARK: ChallengeContentView
    /// 20.0
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 180.0
    static let height: CGFloat = inputViewTitleHeight + contentStackViewSpacing + contentInputviewHeight
    
    // MARK: ContentStackView
    /// 4.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    
    // MARK: InputViewTitle
    /// 18.0
    static let inputViewTitleHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // MARK: ContentInputView
    static let contentInputViewPlaceholder: String = "내용을 자세히 적어보세요 !"
    /// 100
    static let contentInputViewMaxTextCount: Int = 100
    /// 158.0
    static let contentInputviewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.45
}
