//
//  ChatQuestionCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/22.
//

import UIKit

enum ChatQuestionCellNameSpace {
    // MARK: ChatQuestionCell
    /// 80.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 9.85
    /// "ChatQuestionCell"
    static let identifier: String = "ChatQuestionCell"
    
    // MARK: IndexLabel
    /// 14.0
    static let indexLabelFontSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 15.0
    static let indexLabelCornerRadius: CGFloat = 15.0
    /// 12.0
    static let indexLabelTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    /// 12.0
    static let indexLabelLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 12.0
    static let indexLabelBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    
    // MARK: BodyLabel
    /// 16.0
    static let bodyLabelFontSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 12.0
    static let bodyLabelLeaindOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    
    // MARK: ContentView
    /// 0.0
    static let contentViewTopInset: CGFloat = 0.0
    /// 11.0
    static let contentViewLeftInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.93
    /// 12.0
    static let contentViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    /// 11.0
    static let contentViewRightInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.93
    /// 16.0
    static let contentViewCornerRadius: CGFloat = 16.0
    /// 2.0
    static let contentViewBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53
    /// 351.0
    static let contentViewShadowWidth: CGFloat = UIScreen.main.bounds.width - (contentViewLeftInset + contentViewRightInset)
    /// 68.0
    static let contentViewShadowHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 8.37
    /// 16.0
    static let contentViewShadowCornerRadius: CGFloat = 16.0
    /// 0.08
    static let contentViewShadowAlpha: CGFloat = 0.08
    /// 1.0
    static let contentViewShadowOpacity: Float = 1.0
    /// 2.0
    static let contentViewSahdowRadius: CGFloat = 2.0
    /// 0.0
    static let contentViewShadowOffsetWidth: CGFloat = 0.0
    /// 0.0
    static let contentViewShadowOffsetHeight: CGFloat = 0.0
    
    // MARK: NewLabel
    /// "New"
    static let newLabelText: String = "New"
    /// 14.0
    static let newLabelFontSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 22.0
    static let newLabelTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.86
}
