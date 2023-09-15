//
//  ChallengeDetailDescriptionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/23.
//

import UIKit

enum ChallengeDetailDescriptionViewNameSpace {
    // MARK: ChalleneDetailDescriptionView
    static let spacing: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33                 // 20.0
    static let height: CGFloat = (UIScreen.main.bounds.height / 100) * 8.86                 // 72.0
    
    // MARK: HeaderLabel
    static let headerLabelNewOrModifyModeText: String = "자기야 💕"
    static let headerLabelOngoingOrCompletedModeText: String = "자기랑"
    static let headerLabelTextFont: String = "pretendard-regular"
    static let headerLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 6.4      // 24.0
    
    // MARK: BodyLabel
    static let bodyLabelNewOrModifiyModeText: String = "우리 어떤 걸 해볼까?"
    static let bodyLabelOngoingOrCompletedModeText: String = "꼭 해보고 싶어🔥"
    static let bodyLabelTextFont: String = "pretendard-medium"
    static let bodyLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 6.4        // 24.0
}
