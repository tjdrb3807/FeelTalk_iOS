//
//  PartnerAnswerViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit

enum PartnerAnswerViewNameSpace {
    // MARK: PartnerAnswerView
    /// 8.0
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98
    
    // MARK: InputViewTitle
    /// 18.0
    static let inputViewTitleHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // MARK: AnswerTextView
    /// 16.0
    static let answerTextViewTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 12.0
    static let answerTextViewCornerRadius: CGFloat = 12.0
    ///16.0
    static let answerTextViewContainerTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 12.0
    static let answerTextViewContainerLeftInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 16.0
    static let answerTextViewContainerBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 12.0
    static let answerTextViewContainerRightInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 158.0
    static let answerTextViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.45
}
