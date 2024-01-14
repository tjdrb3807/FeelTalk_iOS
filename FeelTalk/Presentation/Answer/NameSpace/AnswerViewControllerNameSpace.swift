//
//  AnswerViewControllerNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit

enum AnswerViewControllerNameSpace {
    // MARK: DimmedView
    /// 0.4
    static let dimmedViewAlpha: CGFloat = 0.4
    /// 0.5
    static let dimmedViewAnimateDuration: CGFloat = 0.5
    /// 0.0
    static let dimmedViewAnimateDelay: CGFloat = 0.0
    
    
    // MARK: BottomSheetView
    /// 20.0
    static let bottomSheetViewCornerRadius: CGFloat = 20.0
    /// 116.0
    static let bottomSheetViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 14.28
    
    // MARK: PopButton
    static let popButtonImage: String = "icon_x_mark_black"
    /// 12.0
    static let popButtonTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    /// 12.0
    static let popButtonLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 48.0
    static let popButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8
    /// 48.0
    static let popButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.91
    
    // MARK: ScrollView
    /// 60.0
    static let scrollViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38
    
    // MARK: StackView
    /// 32.0
    static let stackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.94
    
    // MARK: AnswerCompletedButton
    static let answerCompletedButtonTitleText: String = "답변 완료"
    /// 18.0
    static let answerCompletedButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 29.5
    static let answerCompletedButtonBaseCornerRadius: CGFloat = answerCompletedButtonHeight / 2
    /// 59.0
    static let answerCompletedButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26
    /// 0.0
    static let answerCompletedButtonUpdateCornerRadius: CGFloat = 0.0
}
