//
//  QuestionTableHeaderViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/29.
//

import UIKit

enum QuestionTableHeaderViewNameSpace {
    // MARK: TodayQuesetionView
    static let backgroundColor: String = "main_500"
    static let corderRadius: CGFloat = 16.0
    static let topOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 0.12 // 1
    static let contentViewTopEdegeInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.35 // 11
    static let contentViewLeftEdegeInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2  // 12
    static let contentViewBottomEdegeInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97 // 16
    static let contentViewRightEdegeInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2 // 12
    static let height: CGFloat = (UIScreen.main.bounds.height / 100) * 29.06  // 236
    
    // MARK: QuestionIndexLabel
    static let questionIndexLabelText: String = "100"
    static let questionIndexLabelTextFont: String = "Montserrat-Bold"
    static let questionIndexLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.73  // 14
    static let questionIndexLabelTextColor: String = "main_500"
    static let questionIndexLabelBackgroundColor: String = "main_300"
    static let questionIndexLabelCornerRadius: CGFloat = 15.0
    static let questionIndexLabelLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33 // 20
    static let questionIndexLabelTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97 // 16
    static let questionIndexLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 5.41  // 44
    
    // MARK: NewSignalLabel
    static let newSignalLabelText: String = "New"
    static let newSignalLabelTextFont: String = "Montserrat-Bold"
    static let newSignalLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.73  // 14
    static let newSignalLabelTrailingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 9.6 // 36
    
    // MARK: QuestionLabel
    static let questionLabelTextFont: String = "pretendard-medium"
    static let questionLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33 // 20
    static let questionLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 3.69 // 30
    
    // MARK: QuestionHeaderLabel
    static let questionHeaderLabelText: String = "난 이게 가장 좋더라!"
    static let questionHeaderLabelTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.47  // 12
    
    // MARK: QuestionBodyLabel
    static let questionBodyLabelText: String = "당신이 가장 좋아하는 스킨십은?"
    
    // MARK: QuestionAnswerButton
    static let questionAnswerButtonNormalTitleText: String = "답변 하러가기"
    static let questionAnswerButtonSelectedTitleText: String = "답변 보러가기"
    static let questionAnswerButtonTitleTextFont: String = "pretendard-regular"
    static let questionAnswerButtonTitleTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26 // 16
    static let questionAnswerButtonCornerRadius: CGFloat = questionAnswerButtonHeight / 2
    static let questionAnswerButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 29.6  // 111
    static let questionAnswerButtonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 4.92  // 40
    static let questionAnswerButtonTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97  // 16
    
    // MARK: BackgroundImageView
    static let backgroundImageViewImage: String = "image_question_note"
}
