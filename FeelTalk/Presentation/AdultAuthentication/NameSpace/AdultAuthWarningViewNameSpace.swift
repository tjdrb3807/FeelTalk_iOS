//
//  AdultAuthWarningViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/05.
//

import Foundation

enum AdultAuthWarningViewNameSpace {
    // AdultAuthWarningView
    /// 18.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // WarningLabel
    static let warningLabelText: String = "본인인증 약관에 동의해주세요."
    /// 12.0
    static let warningLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 18.0
    static let warningLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    /// 6.0
    static let warningLabelLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.6
    /// 6.0
    static let warningLabelTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.6
}
