//
//  AdultAuthNumberDescriptionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/05.
//

import Foundation

enum AdultAuthNumberDescriptionViewNameSpace {
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.6         // 6.0
    static let contentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.6    // 6.0
    static let contentStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.6   // 6.0
    
    // DescriptionLabel
    static let descriptionLabelText: String = """
                                              입력한 인증정보가 올바르지 않은 경우, 인증번호가 도착하지 않을 수 있어요.
                                              """
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2        // 12.0
    static let descriptionLabelNumberOfLines: Int = 0
    static let desctiptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21       // 18.0
}
