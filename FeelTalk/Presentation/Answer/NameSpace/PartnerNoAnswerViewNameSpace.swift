//
//  PartnerNoAnswerViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/03.
//

import UIKit

enum PartnerNoAnswerViewNameSpace {
    // MARK: PartnerNoAnswerView
    static let backgroundColor: String = "gray_200"
    static let cornerRadius: CGFloat = 12.0
    
    // MARK: TitleLabel
    static let titleLabelText: String = "연인이 아직 답변을 작성하지 않았어요 😢"
    static let titleLabelTextColor: String = "gray_600"
    static let titleLabelTextFont: String = "pretendard-regular"
    static let titleLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26  // 16
    static let titleLabelTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 5.04  // 41
    static let titleLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 2.95  // 24
    
    // MARK: AnswerChaseUpButton
    static let answerChaseUpButtonTitleText: String = "콕 찔러서 답변 요청하기"
    static let answerChaseUpButtonTitleTextFont: String = "pretendard-medium"
    static let answerChaseUpButtonTitleTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.8  // 18
    static let answerChaseUpButtonBottomInset: CGFloat = (UIScreen.main.bounds.height / 100) * 5.04  // 41
    static let answerChaseUpButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 53.0  // 199
    static let answerChaseUpButotnHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 6.28
    static let answerCuaseUpButtonCornerRadius: CGFloat = answerChaseUpButotnHeight / 2
}
