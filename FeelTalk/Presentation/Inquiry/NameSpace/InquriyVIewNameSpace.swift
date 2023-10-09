//
//  InquriyVIewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import Foundation

enum InquriyVIewNameSpace {
    // MARK: TotalStackView
    static let totalStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.94        // 32.0
    
    // MARK: DescriptionLabel
    static let descriptionLabelText: String = """
                                              필로우톡을 이용할 때
                                              불편한 점이 있으셨나요?
                                              """
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.40   // 24.0
    static let descriptionLabelNumberOfLines: Int = 0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43   // 36.0
    
    // MARK: SubmitButton
    static let submitButtonTitleText: String = "제출하기"
}
