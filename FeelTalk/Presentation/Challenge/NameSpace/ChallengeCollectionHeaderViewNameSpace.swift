//
//  ChallengeCollectionHeaderViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/07.
//

import UIKit

enum ChallengeCollectionHeaderViewNameSpace {
    // MARK: StackView
    static let stackViewTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 3.94      // 32.0
    static let stackViewLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.6    // 21.0
    static let stackViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 8.86        // 72.0
    
    // MARK: HeaderLabel
    static let headerLabelText: String = "너랑 하고 싶은"
    static let headerLabelFont: String = "pretendard-regular"
    static let headerLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 6.4      // 24.0
    
    // MARK: BodyLabel
    static let bodyLabelDefaultText: String = "개의 챌린지"
    static let bodyLAbelHighlightText: String = "개"
    static let bodyLabelFont: String = "pretendard-medium"
    static let bodyLabelFextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 6.3        // 24.0
    static let bodyLabelHighlightTextColor: String = "main_500"
    
}
