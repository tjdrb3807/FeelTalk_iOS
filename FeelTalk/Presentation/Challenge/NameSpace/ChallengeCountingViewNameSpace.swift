//
//  ChallengeCountingViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/26.
//

import Foundation

enum ChallengeCountingViewNameSpace {
    // ChallengeCountingView
    static let Height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 13.79                          // 112.0
    
    // ContentStackView
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.94         // 32.0
    static let contentStackViewBottomOffset: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 0.98)  // -8.0
    
    // FirstAdditionalLabel
    static let firstAdditionalLabelText: String = "너랑 하고 싶은"
    static let firstAdditionalLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4    // 24.0
    
    // TotalCountLabel
    static let totalCountLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4         // 24.0
    static let totalCountLabelSubText: String = "개"
    
    // SecondAdditionalLabel
    static let secondAdditionalLabelText: String = "의 챌린지"
    static let secondAdditionalLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4   // 24.0
}
