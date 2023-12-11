//
//  NewsAgencyViewControllerNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/10.
//

import Foundation

enum NewsAgecnyViewControllerNameSpace {
    // NewsAgecnyViewController
    /// 317.0
    static let bottomSheetViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 39.03
    
    // TitleLabel
    static let titleLabelText: String = "통신사를 선택해주세요."
    /// 20.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 30.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69
    /// 41.0
    static let titleLabelTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.04
    
    // ButtonStackView
    /// 8.0
    static let buttonStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98
    /// 91.0
    static let buttonStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 11.20
}
