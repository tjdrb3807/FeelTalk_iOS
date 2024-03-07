//
//  ChatChallengeCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/27.
//

import Foundation

enum ChatChallengeCellNameSpace {
    // MARK: CHatChallengeCell
    /// 160.0
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 42.66
    /// 181.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 22.29
    /// 12.0
    static let cornerRadius: CGFloat = 12.0
    /// "ChatChallengeCell"
    static let identifier: String = "ChatChallengeCell"
    
    // MARK: ContentView
    /// 12.0
    static let contentViewCornerRadius: CGFloat = 12.0
    /// 2.0
    static let contentViewBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53
    
    // MARK: Shadow
    /// 12.0
    static let shadowCornerRadius: CGFloat = 12.0
    /// 0.08
    static let shadowAlpha: CGFloat = 0.08
    /// 1.0
    static let shadowOpacity: Float = 1.0
    /// 2.0
    static let shadowRadius: CGFloat = 2.0
    /// 0.0
    static let shadowOffsetWidth: CGFloat = 0.0
    /// 0.0
    static let shadowOffsetHeight: CGFloat = 0.0
    
    // MARK: DdayLabel
    /// 15.0
    static let dDayLabelCornerRadius: CGFloat = dDayLabelHeight / 2
    /// 12.0
    static let dDayLabelFontSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 30.0
    static let dDayLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69
    /// 16.0
    static let dDayLabelTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 56.0
    static let dDayLabelWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 14.93
    
    // MARK: TitleLabel
    /// 0
    static let titleLabelNumberOfLines: Int = 0
    /// 16.0
    static let titleLabelFontSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 8.0
    static let titleLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98
    
    // MARK: NicknameLabel
    /// 14.0
    static let nicknameLabelFontSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 16.0
    static let nicknameLabelBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 12.0
    static let nicknameHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
    
}
