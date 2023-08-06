//
//  PartnerAnswerViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit

enum PartnerAnswerViewNameSpace {
    // MARK: PartnerAnswerView
    static let spacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.98  // 8
    static let noAnswerTypeHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 23.76  // 193
    static let gotAnserTypeHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 10.09  // 82
    
    // MARK: TitleLabel
    static let titleLabelText: String = "연인의 답변"
    static let titleLabelTextColor: String = "gray_500"
    static let titleLabelTextFont: String = "pretendard-bold"
    static let titleLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2  // 12
    
    // MARK: AnswerTextView
    static let answerTextViewTextFont: String = "pretendard-regular"
    static let answerTextViewTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26  // 16
    static let answerTextViewBackgroundColor: String = "gray_200"
    static let answerTextViewCornerRadius: CGFloat = 12.0
    static let answerTextViewContainerTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97    // 16
    static let answerTextViewContainerLeftInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2     // 12
    static let answerTextViewContainerBottomInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97    // 16
    static let answerTextViewContainerRightInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2     // 12
}
