//
//  ChallengeDeadlineViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/13.
//

import Foundation

enum ChallengeDeadlineViewNameSpace {
    // MARK: ChallengeDeadlineView
    /// 20.0
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 78.0
    static let height: CGFloat = inputViewTitleHeight + contentStackViewSpacing + inputStackViewHeight
    
    // MARK: InputViewTitle
    /// 18.0
    static let inputViewTitleHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // MARK: ContentStackView
    /// 4.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    
    // MARK: InputStackView
    /// 12.0
    static let inputStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 56.0
    static let inputStackViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
    
    // MARK: DeadlineInputView
    
    
    // MARK: CalenderIcon
    /// 48.0
    static let calenderIconWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8
    /// 48.0
    static let calenderIconHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.91
    static let calenderIconImage: String = "icon_calender"
    
    // MARK: DdayLabel
    /// 16.0
    static let dDayLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 12.0
    static let dDayLabelCornerRadius: CGFloat = 12.0
    /// 85.0
    static let dDayLabelWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 22.66
}

