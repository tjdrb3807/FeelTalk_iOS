//
//  AdultAuthNewsAgencyButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/07.
//

import Foundation

enum AdultAuthNewsAgencyButtonNameSpace {
    // AdultAuthNewsAgencyButton
    /// 12.0
    static let cornerRadius: CGFloat = 12.0
    /// 2.0
    static let borderWidthOfActice: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53
    /// 1.0
    static let borderWidthOfNonActice: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26
    /// 110.0
    static let defaultWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 29.33
    /// 136.0
    static let thriftyTypeWidht: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 36.26
    /// 56.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
    
    // NewsAgencyLabel
    /// 16.0
    static let newsAgencyLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 12.0
    static let newsAgencyLabelLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    
    // ArrowIcon
    static let arrowIconImage: String = "icon_arrow_gray"
    /// 12.0
    static let arrowIconTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 24.0
    static let arrowIconWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4
    /// 24.0
    static let arrowIconHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
}
