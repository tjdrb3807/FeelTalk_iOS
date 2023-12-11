//
//  LoginSpeechBubbleViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/21.
//

import Foundation

enum LoginSpeechBubbleViewNameSpace {
    // LoginSpeechBubbleView
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 32.0              // 120.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.06               // 33.0
    static let leadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 8.53       // 32.0
    static let bottomOffset: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 0.36)      // -3.0
    static let tipStartX: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.46          // 13.0
    static let tipStartY: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.70            // 22.0
    static let tipSecondX: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.0          // 22.5
    static let tipSecondY: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.04           // 41.0
    static let tipThirdX: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 8.54          // 32.0
    static let tipThirdY: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator *  2.70           // 22.0
    static let tipEndX: CGFloat = tipStartX
    static let tipEndY: CGFloat = tipStartY
    
    // TitleLabel
    static let titelLabelText: String = "3초만에 시작하기"
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73 // 14.0
}
