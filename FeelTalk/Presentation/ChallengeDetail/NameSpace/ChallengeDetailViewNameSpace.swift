//
//  ChallengeDetailViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/24.
//

import UIKit

enum ChallengeDetailViewNameSpace {
    // MARK: VerticalStackView
    static let verticalStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 3.94           // 32.0
    
    // MARK: ChallengeButton
    static let challengeButtonNewModeTitle: String = "챌린지 만들기"
    static let challengeButtonOngoingModeTitle: String = "챌린지 완료"
    static let challengeButtonCompletedModeTitle: String = "이미 완료된 챌린지예요"
    static let challengeButtonModifyModeTitle: String = "챌린지 수정"
    static let challengeButtonTitleFont: String = "pretendard-medium"
    static let challengeButtonTitleSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.8     // 18.0
    static let challengeButtonNewModeDisableStateBackgroundColor: String = "main_400"
    static let challengeButtonNewOrOngoingModeEnableStateBackgroundColor: String = "main_500"
    static let challengeButtonCompletedModeBackgroundColor: String = "gray_400"
    static let challengeButtonCornerRadius: CGFloat = challengeButtonHeight / 2
    static let challengeButtonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.26      // 59.0
    static let challengeButtonSideInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33    // 20.0
}
