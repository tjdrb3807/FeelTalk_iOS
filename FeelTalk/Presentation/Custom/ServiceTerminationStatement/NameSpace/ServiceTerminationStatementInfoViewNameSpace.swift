//
//  ServiceTerminationStatementInfoViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/06.
//

import Foundation

enum ServiceTerminationStatementInfoViewNameSpace {
    // ServiceTerminationStatementInfoView
    static let cornerRadius: CGFloat = 8.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.60                     // 13.0
    
    // InfoStackView
    static let infoStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98          // 8.0
    static let infoStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97         // 16.0
    static let infoStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2    // 12.0
    static let infoStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2   // 12.0
    static let infoStackViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97      // 16.0
    static let infoStackViewFirstComponentsIndex: Int = 0
    static let infoStackViewSecondComponentsIndex: Int = 1
    static let infoStackViewThirdComponentsIndex: Int = 2
}
