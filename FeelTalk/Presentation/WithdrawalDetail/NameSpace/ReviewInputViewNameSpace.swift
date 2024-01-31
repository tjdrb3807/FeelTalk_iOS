//
//  ReviewInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum ReviewInputViewNameSpace {
    // MARK: ReviewInputView
    /// 20.0
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 187.0
    static let height: CGFloat = headerLabelLineHeight + contentStackViewSpacing + reviewInputTextViewHeight
    
    // MARK: ContentStackView
    /// 8.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98
    
    // MARK: HeaderLabel
    /// "필로우톡에 남기고 싶은 말"
    static let headerLabelText: String = "필로우톡에 남기고 싶은 말"
    /// 14.0
    static let headerLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 21.0
    static let headerLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
    
    // MARK: ReviewInputTextView
    /// "필로우톡에 남기고 싶은 말을 입력해주세요."
    static let reviewInputTextViewPlaceholder: String = "필로우톡에 남기고 싶은 말을 입력해주세요."
    /// 100
    static let reviewInputTextViewMaxCount: Int = 100
    /// 158.0
    static let reviewInputTextViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.45
}
