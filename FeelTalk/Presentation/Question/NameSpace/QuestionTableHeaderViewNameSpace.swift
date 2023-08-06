//
//  QuestionTableHeaderViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/29.
//

import UIKit

enum QuestionTableHeaderViewNameSpace {
    // MARK: QuestionTableHeaderView
    static let x: CGFloat = 0.0
    static let y: CGFloat = 0.0
    static let height: CGFloat = (UIScreen.main.bounds.height / 100) * 43.84                            // 356
    
    // MARK: SpacingView
    static let spacingViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.38                  // 60
    
    // MARK: TodqyQuestionView
    static let todayQuestionViewBackgroundColor: String = "main_500"
    static let todayQuestionViewCornerRadius: CGFloat = 16.0
    static let todayQuestionViewTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.47         // 12
    static let todayQuestionViewLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2        // 12
    static let todqyQuestionViewWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 93.6              // 351
    static let todayQuestionViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 25.61           // 208
    
    // MARK: QuestionIndexLabel
    static let questionIndexLabelTextColor: String = "main_500"
    static let questionIndexLabelTextFont: String = "Montserrat-Bold"
    static let questionIndexLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.73          // 14
    static let questionIndexLabelBackgroundColor: String = "main_300"
    static let questionIndexLabelCornerRadius: CGFloat = 15.0
    static let questionIndexLabelTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97         // 16
    static let questionIndexLabelLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33      // 20
    static let questionIndexLabelWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 11.73            // 44
    static let questionIndexLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 5.41
    
    // MARK: NewSignalLabel
    static let newSignalLabelText: String = "New"
    static let newSignalLabelTextFont: String = "Montserrat-Bold"
    static let newSignalLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.73              // 14
    static let newSignalLabelTrailingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 9.6          // 36
    
    // MARK: QuestionLabel (header, body)
    static let questionLabelTextFont: String = "pretendard-medium"
    static let questionLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33               // 20
    static let questionLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 3.69                // 30
    
    // MARK: QuestionHeaderLabel
    static let questionHeaderLabelTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.72       // 14
    static let questionHeaderLabelLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33     // 20
    
    // MARK: QuestionAnswerButton
    static let questionAnswerButtonBaseTitleText: String = "답변 하러가기"
    static let questionAnswerButtonUpdateTitleText: String = "답변 보러가기"
    static let questionAnswerButtonTitleTextFont: String = "pretendard-regular"
    static let questionAnswerButtonTitleTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26   // 16
    static let questionAnswerButtonUpdateTitleTextColor: String = "main_500"
    static let questionAnswerButtonUpdateBackgroundColor: String = "main_100"
    static let qusetionAnswerButtonCornerRadius: CGFloat = questionAnswerButtonHeight / 2
    static let questionAnswerButtonTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 2.21      // 18
    static let qusetionAnswerButtonLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33    // 20
    static let questionAnswerButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 29.6           // 111
    static let questionAnswerButtonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 4.92         // 40
    
    // MARK: BackgroundImageView
    static let backgroundImageViewImage: String = "image_question_note"
    static let backgroundImageViewTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.10       // 9
    static let backgroundImageViewLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 53.86    // 202
    
    // MARK: SectionHeaderLabel
    static let sectionHeaderLabelText: String = "우리가 나눈 필로우톡"
    static let sectionHeaderLabelTextFont: String = "pretendard-medium"
    static let sectionHeaderLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.8           // 18
    static let sectionHeaderLabelTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97        // 16
    static let sectionHeaderLabelLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33      // 20
    static let sectionHeaderLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.38           // 60
    
}
