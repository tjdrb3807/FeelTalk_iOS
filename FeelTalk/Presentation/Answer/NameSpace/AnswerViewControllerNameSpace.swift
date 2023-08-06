//
//  AnswerViewControllerNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit

enum AnswerViewControllerNameSpace {
    // MARK: DimmedView
    static let dimmedViewAlpha: CGFloat = 0.4
    static let dimmedViewAnimateDuration: CGFloat = 0.5
    static let dimmedViewAnimateDelay: CGFloat = 0.0
    
    
    // MARK: BottomSheetView
    static let bottomSheetViewCornerRadius: CGFloat = 20.0
    static let bottomSheetViewBaseHeight: CGFloat = 0.0
    static let bottomSheetViewUpdateHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 86.20  // 700
    
    // MARK: PopButton
    static let popButtonImage: String = "icon_x_mark_black"
    static let popButtonTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.47  // 12
    static let popButtonLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2  // 12
    static let popButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 12.8  // 48
    
    // MARK: ScrollView
    static let scrollViewSideInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33  // 20
    static let scrollViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 78.81  // 640
    
    // MARK: StackView
    static let stackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 3.94  // 32
    
    // MARK: AnswerCompletedButton
    static let answerCompletedButtonTitleText: String = "답변 완료"
    static let answerCompletedButtonUpdateTitleText: String = "필로우톡 나누기"
    static let answerCompletedButtonTitleTextFont: String = "pretendard-medium"
    static let answerCompletedButtonTitleTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.8  // 18
    static let answerCompletedButtonDeactivationBackgroundColor: String = "main_400"
    static let answerCompletedButtonActivationBackgroundColor: String = "main_500"
    static let answerCompletedButtonBaseSideInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33  // 20
    static let answerCompletedButtonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.26  // 59
    static let answerCompletedButtonBaseCornerRadius: CGFloat = answerCompletedButtonHeight / 2
    static let answerCompletedButtonUpdateCornerRadius: CGFloat = 0.0
}
