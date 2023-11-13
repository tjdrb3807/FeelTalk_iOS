//
//  HomeTodayQuestionDescriptionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/20.
//

import Foundation

enum HomeTodayQuestionDescriptionViewNameSpace {
    // HomeTodayQuestionDescriptionView
    static let cornerRadius: CGFloat = 8.0
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 54.66                     // 205.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.55                       // 37.0
    static let topInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69                     // 30.0
    
    // DescriptionLabel
    static let descriptionLabelText: String = "오늘도 서로에 대해 더 알아가봐요!"
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73   // 24.0
}
