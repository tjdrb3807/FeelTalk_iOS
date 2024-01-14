//
//  ChallengeButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/14.
//

import Foundation

enum ChallengeButtonNameSpace {
    // MARK: ChallengeButton
    /// 29.5
    static let cornerRadius: CGFloat = height / 2
    /// 59.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26
    static let completedTypeTitleText: String = "이미 완료된 챌린지예요"
    static let modifyTypeTitleText: String = "챌린지 수정"
    static let newTypeTitleText: String = "챌린지 만들기"
    static let ongoingTypeText: String = "챌린지 완료"
}
