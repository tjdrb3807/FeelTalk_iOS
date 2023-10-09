//
//  BreakUpServiceDataCountViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import Foundation

enum BreakUpServiceDataCountViewNameSpace {
    // BreakUpServiceDataCountView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.23                          // 10.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 15.30                          // 125.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.44                        // 28.0
    
    // DescriptionLabel
    static let descriptionLabelText: String = "연인과 함께한"
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8        // 18.0
    static let descriptionLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.32           // 27.0
    
    // CountStaackView
    static let countStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49            // 4.0
    
    // ServiceCountStackView
    static let serviceCountStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06   // 4.0
    
    // ServiceCountLabel
    static let serviceCountLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 7.46      // 28.0
    
    // ServiceDescriptionLabel
    static let serviceDescriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4 // 24.0
    
    // QuestionDescriptionLabel
    static let questionDescriptionLabelText: String = "개의 질문 답변 내용과"
    
    // ChallengeDescriptionLabel
    static let challengeDescriptionLabelText: String = "개의 챌린지 기록이 있어요"
}
