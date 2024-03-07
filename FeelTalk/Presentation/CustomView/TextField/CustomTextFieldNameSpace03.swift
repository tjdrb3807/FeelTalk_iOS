//
//  CustomTextFieldNameSpace03.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/12.
//

import Foundation

enum CustomTextFieldNameSpace03 {
    // MARK: CustomTextField
    /// 4.0
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.73
    
    // MARK: TextField
    /// 16.0
    static let textFieldTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 2.0
    static let textFieldBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53
    /// 12.0
    static let textFieldCornerRadius: CGFloat = 12.0
    /// 12.0
    static let textFieldLeftViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 56.0
    static let textFieldHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
    
    // MARK: CountView
    /// 12.0
    static let countViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    
    // MARK: LabelStackView
    /// 6.0
    static let labelStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.6
    /// 18.0
    static let labelStackViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // MARK: WarningLabel
    /// 12.0
    static let warningLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
}
