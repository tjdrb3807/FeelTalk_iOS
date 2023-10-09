//
//  SuggestionsIdeaInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/26.
//

import Foundation

enum SuggestionsIdeaInputViewNameSpace {
    // MARK: SuggestionsIdeaInputView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47                  // 12.0
    
    // MARK: IdeaInputTextView
    static let ideaInputTextViewPlaceholder: String = "질문을 입력해주세요"
    static let ideaInputTextViewMaxTextCount: Int = 100
    static let ideaInputTextViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.45 // 158.0
}
