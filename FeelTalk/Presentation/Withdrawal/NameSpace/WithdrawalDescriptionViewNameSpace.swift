//
//  WithdrawalDescriptionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/07.
//

import Foundation

enum WithdrawalDescriptionViewNameSpace {
    //WithdrawalDescriptionView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49                  // 4.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 14.28                  // 14.28
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38                // 60.0
    
    // LabelCommon
    static let labelCommonTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4     // 24.0
    static let labelCommonLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43    // 36.0
    
    // FirstLineLabel
    static let firstLineLabelText: String = "필로우톡을"
    
    // SecondLineLabel
    static let secondLineLabelText: String = "떠나려는 당신에게"
    
    // ThirdLineLabel
    static let thirdLineLableText: String = "알려드려요"
}
