//
//  LockingPasswordInputViewCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/20.
//

import Foundation

enum LockingPasswordInputViewCellNameSpace {
    // MARK: CircleView
    static let circleViewCornerRadius: CGFloat = circleViewHeight / 2  // 6.0
    static let circleViewHorizontalInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06  // 4.0
    static let circleViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47             // 12.0
    
    // MARK: BarView
    static let barViewTopOffset: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 0.24)          // -2.0
}
