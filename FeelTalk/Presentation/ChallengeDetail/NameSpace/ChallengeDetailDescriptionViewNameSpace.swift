//
//  ChallengeDetailDescriptionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/23.
//

import UIKit

enum ChallengeDetailDescriptionViewNameSpace {
    // MARK: ChallengeDetailDescriptionView
    /// 20.0
    static let spacing: CGFloat = CommonConstraintNameSpace.leadingInset
    /// 72.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 8.86
    
    // MARK: Label
    /// 24.0
    static let labelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4
    
    // MARK: HeaderLabel
    static let headerLabelType01Text: String = "자기랑"
    static let headerLabelType02Text: String = "자기야 💕"
    
    // MARK: bodyLabel
    static let bodyLabelType01Text: String = "꼭 해보고 싶어🔥"
    static let bodyLabelType02Text: String = "우리 어떤 걸 해볼까?"
}
