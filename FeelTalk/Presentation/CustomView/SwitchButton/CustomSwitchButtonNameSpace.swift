//
//  CustomSwitchButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/19.
//

import Foundation

enum CustomSwitchButtonNameSpace {
    // MARK: SwitchButton
    static let animationDuration: CGFloat = 0.25
    static let animationDelay: CGFloat = 0.0
    
    // MARK: BarView
    static let barViewCornerRadius: CGFloat = barViewHeight / 2
    static let barViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8                           // 48.0
    static let barViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.44                            // 28.0
    
    // MARK: CircleView
    static let circleViewCornerRadius: CGFloat = circleViewHeight / 2
    static let circleViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33                        // 20.0
    static let circleViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46                         // 20.0
    static let circleViewOnStateCenterXOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66         // 10.0
    static let circleViewOffStateCenterXOffset: CGFloat = -(CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66)     // -10.0
}
