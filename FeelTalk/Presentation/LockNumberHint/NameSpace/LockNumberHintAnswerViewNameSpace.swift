//
//  LockNumberHintAnswerViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/08.
//

import Foundation

enum LockNumberHintAnswerViewNameSpace {
    // MARK: LockNumberHintAnswerView
    /// 20.0
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 78.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 9.60
    
    
    // MARK: ContentStackView
    /// 4.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    
    // MARK: InputTitleView
    /// 18.0
    static let inputTitleViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // MARK: InputView
    /// 56.0
    static let inputViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
    /// 1
    static let inputViewIndex: Int = 1
    
    // MARK: TextInputView
    /// "질문에 알맞은 답변을 작성해주세요"
    static let textInputViewPlaceholder: String = "질문에 알맞은 답변을 작성해주세요"
    /// 10
    static let textInputViewMexCount: Int = 10
    
    // MARK: DateInputView
    /// ""
    static let dateInputViewPlaceholder: String = ""
    /// 0
    static let dateInputViewMaxCount: Int = 0
    /// "ko-KR"
    static let dateInputViewFormatterIdentifier: String = "ko-KR"
    /// "yyyy년 M월 dd일"
    static let dateInputViewFormatter = "yyyy년 M월 dd일"
    
    // MARK: WarningLabel
    /// 12.0
    static let warningLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 18.0
    static let warningLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
}
