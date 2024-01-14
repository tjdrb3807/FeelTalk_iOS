//
//  MainNavigationBarNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/07.
//

import Foundation

enum MainNavigationBarNameSpace {
    // MARK: MainNavigationBar
    /// 60.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38
    /// 0.0
    static let shadowPathCornerRadius: CGFloat = 0.0
    /// 0.08
    static let shadowColorAlpha: CGFloat = 0.08
    /// 1.0
    static let shadowOpacity: Float = 1.0
    /// 1.0
    static let shadowRadius: CGFloat = 1.0
    /// 0.0
    static let shadowOffsetWidth: CGFloat = 0.0
    /// 1.0
    static let shadowOffsetHeight: CGFloat = 1.0
    
    // MARK: TitleLabel
    /// 18.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    
    // MARK: LogoImageView
    /// 96.0
    static let logoImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 25.6
    /// 28.0
    static let logoImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.44
}
