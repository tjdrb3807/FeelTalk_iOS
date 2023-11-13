//
//  HomeTodayQuestionCountViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/19.
//

import Foundation

enum HomeTodayQuestionCountViewNameSpace {
    // HomeTodayQuestionCountView
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 8.12                            // 66.0
    static let topInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 10.22                         // 83.0
    
    // DescriptionLabel
    static let descriptionLabelText: String = "두근두근!"
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33        // 20.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69        // 30.0
    
    // CountLabel
    static let countLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4               // 24.0
    static let countLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43              // 36.0
    
    // CountDescriptionLabel
    static let countDescriptionLabelText: String = "번째 질문이 도착했어요"
    static let countDescriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33   // 20.0
    static let countDescriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69   // 30.0
}
