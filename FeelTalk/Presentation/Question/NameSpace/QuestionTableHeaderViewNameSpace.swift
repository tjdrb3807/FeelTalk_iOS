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
    /// 356.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 43.84                           
    
    // MARK: SpacingView
    /// 60.0
    static let spacingViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38
    
    // MARK: TodqyQuestionView
    static let todayQuestionViewBackgroundColor: String = "main_500"
    /// 16.0
    static let todayQuestionViewCornerRadius: CGFloat = 16.0
    /// 12.0
    static let todayQuestionViewTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    /// 12.0
    static let todayQuestionViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 351.0
    static let todqyQuestionViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 93.6
    /// 208.0
    static let todayQuestionViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 25.61          
    
    // MARK: QuestionIndexLabel
    /// 14.0
    static let questionIndexLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 15.0
    static let questionIndexLabelCornerRadius: CGFloat = 15.0
    /// 16.0
    static let questionIndexLabelTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 20.0
    static let questionIndexLabelLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 44.0
    static let questionIndexLabelWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 11.73
    /// 44.0
    static let questionIndexLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.41
    
    // MARK: NewSignalLabel
    static let newSignalLabelText: String = "New"
    /// 14.0
    static let newSignalLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 36.0
    static let newSignalLabelTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 9.6
    
    // MARK: QuestionLabel (header, body)
    /// 20.0
    static let questionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 30.0
    static let questionLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69
    
    // MARK: QuestionHeaderLabel
    /// 14.0
    static let questionHeaderLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.72
    /// 20.0
    static let questionHeaderLabelLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    
    // MARK: QuestionAnswerButton
    static let questionAnswerButtonBaseTitleText: String = "답변 하러가기"
    static let questionAnswerButtonUpdateTitleText: String = "답변 보러가기"
    /// 16.0
    static let questionAnswerButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    static let questionAnswerButtonUpdateTitleTextColor: String = "main_500"
    static let questionAnswerButtonUpdateBackgroundColor: String = "main_100"
    /// 20.0
    static let qusetionAnswerButtonCornerRadius: CGFloat = questionAnswerButtonHeight / 2
    /// 18.0
    static let questionAnswerButtonTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    /// 20.0
    static let qusetionAnswerButtonLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 111.0
    static let questionAnswerButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 29.6
    /// 40.0
    static let questionAnswerButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.92
    
    // MARK: BackgroundImageView
    static let backgroundImageViewImage: String = "image_question_note"
    
    // MARK: SectionHeaderLabel
    static let sectionHeaderLabelText: String = "우리가 나눈 필로우톡"
    /// 18.0
    static let sectionHeaderLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 16.0
    static let sectionHeaderLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 20.0
    static let sectionHeaderLabelLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 60.0
    static let sectionHeaderLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38
    
}
