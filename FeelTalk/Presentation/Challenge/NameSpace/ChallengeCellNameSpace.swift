//
//  ChallengeCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/27.
//

import Foundation

enum ChallengeCellNameSpace {
    // MARK: ChallengeCell
    static let identifier: String = "ChallengeCell"
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 42.66                 // 160.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 22.29                  // 181.0
    static let cornerRadius: CGFloat = 12.0
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53            // 2.0
    static let shadowColorAlpha: CGFloat = 0.08
    static let shadowOpacity: Float = 1.0
    static let shadowRadius: CGFloat = 2.0
    static let shadowOffsetWidth: CGFloat = 0.0
    static let shadowOffsetHeight: CGFloat = 0.0
    
    // MARK: DateLabel
    /// 15.0
    static let dateLabelCornerRadius: CGFloat = dateLabelHeight / 2
    /// 12.0
    static let dateLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.0
    /// 77.0
    static let dateLabelCompletedTypeWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 20.53
    /// 56.0
    static let dateLabelOngoingTypeWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 14.93
    /// 16.0
    static let dateLabelTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 30.0
    static let dateLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69

    
    // MARK: TitleLabel
    /// 0
    static let titleLabelNumberOfLines: Int = 0
    /// 16.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 24.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    /// 8.0
    static let titleLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98    
    
    // NicknameLabel
    static let nicknameLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73  // 14.0
    static let nicknameLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58  // 21.0
    static let nicknameLabelBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97 // 16.0
}
