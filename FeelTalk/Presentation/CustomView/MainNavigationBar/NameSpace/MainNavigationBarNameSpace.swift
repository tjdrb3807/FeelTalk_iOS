//
//  MainNavigationBarNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/02.
//

import Foundation

enum MainNavigationBarNameSpace {
    // MARK: MainNavigationBar
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38               // 60.0
    static let shadowPathCornerRadius: CGFloat = 0.0
    static let shadowRedColor: CGFloat = 0.0
    static let shadowGreenColor: CGFloat = 0.0
    static let shadowBlueColor: CGFloat = 0.0
    static let shadowColorAlpha: CGFloat = 0.08
    static let shadowOpacity: Float = 1.0
    static let shadowRadius: CGFloat = 1.0
    static let shadwoOffsetWidth: CGFloat = 0.0
    static let shadowOffsetHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.12   // 1.0
    
    
    // MARK: TitleLabel
    static let titleLableQuestionTypeText: String = "질문"
    static let titleLabelChallengeTypeText: String = "섹스챌린지"
    static let titleLabelMyPageTypeText: String = "마이페이지"
    static let titleLAbelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8  // 18.0
}
