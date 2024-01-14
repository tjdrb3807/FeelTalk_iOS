//
//  ChallengeTitleInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/12.
//

import Foundation

enum ChallengeTitleInputViewNameSpace {
    // MARK: ChallengeTitleInputView
    /// 20.0
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 78.0
    static let height: CGFloat = inputViewHeight + contentStackViewSpacing + titleInputViewHeight
    
    // MARK: InputViewTitle
    /// 18.0
    static let inputViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // MARK: ContentStackView
    /// 4.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    
    // MARK: TitleInputview
    static let titleInputViewPlaceholder: String = "함께하고 싶은 챌린지를 작성해 주세요"
    /// 20
    static let titleInputViewTextLimit: Int = 20
    /// 56.0
    static let titleInputViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
}
