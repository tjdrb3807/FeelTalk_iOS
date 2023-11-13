//
//  HomeTodayQuestionAnswerButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/20.
//

import Foundation

enum HomeTodayQuestionAnswerButtonNameSpace {
    // HomeTodayQuestionAnswerButton
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53                // 2.0
    static let cornerRadius: CGFloat = height / 2
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.28                       // 51.0
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 40.0                      // 150.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.83                    // 23.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06    // 4.0
    
    // ContentLabel
    static let contentLableTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8        // 18.0
    static let contentLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.32       // 27.0
    static let contentLabelCompletionAnswerTypeText: String = "답변보기"
    static let contentLabelNoAnswerTypeText: String = "답변하기"
    
    // RightArrowImageView
    static let rightImageViewCompletionAnswerTypeImage: String = "icon_right_arrow_white"
    static let rightImageViewNoAnswerTypeImage: String = "icon_right_arrow_main500"
    
}
