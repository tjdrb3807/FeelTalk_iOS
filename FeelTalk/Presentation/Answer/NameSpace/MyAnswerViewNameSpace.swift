//
//  MyAnswerViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit

enum MyAnswerViewNameSpace {
    // MARK: MyAnswerView
//    static let spacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.98  // 8
//    static let height: CGFloat = (UIScreen.main.bounds.height / 100) * 21.92  // 178
//    
//    // MARK: TitleLabel
//    static let titleLabelText: String = "나의 답변"
//    static let titleLabelTextColor: String = "gray_500"
//    static let titleLabelTextFont: String = "pretendard-bold"
//    static let titleLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2  // 12
//    
//    // MARK: AnswerTextView
//    static let answerTextViewTextFont: String = "pretendard-regular"
//    static let answerTextViewTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26  // 16
//    static let answerTextViewBackgroundColor: String = "gray_200"
//    static let answerTextViewCornerRadius: CGFloat = 12.0
//    static let answerTextViewTintColor: String = "main_500"
//    static let answerTextViewPlaceHolderText: String = "질문에 대해 답변을 적어보세요!"
//    static let answerTextViewPlaceHolderTextColor: String = "gray_400"
//    static let answerTextViewBaseUpdateBorderColor: String = "main_500"
//    static let answerTextViewBorderWitdh: CGFloat = (UIScreen.main.bounds.width / 100) * 0.53 // 2
//    static let answerTextViewContainerTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97  // 16
//    static let answerTextViewContainerLeftInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2  // 12
//    static let answerTextViewContainerBottomInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97  // 16
//    static let answerTextViewContainerRightInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2  // 12
    
    // MARK: MyAnswerView
    /// 4.0
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.40
    /// 180.0
    static let height: CGFloat = inputViewTitleHeight + spacing + answerInputViewHeight
    
    // MARK: inputViewTitle
    /// 18.0
    static let inputViewTitleHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // MARK: AnswerInputView
    static let answerInputViewPlaceholder: String = "질문에 대해 답변을 적어보세요 !"
    static let answerInputViewMaxNumberOfChar: Int = 100
    /// 158.0
    static let answerInputViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.45
    
}
