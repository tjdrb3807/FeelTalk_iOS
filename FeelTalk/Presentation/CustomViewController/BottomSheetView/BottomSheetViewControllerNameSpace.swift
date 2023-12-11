//
//  BottomSheetViewControllerNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/09.
//

import Foundation

enum BottomSheetViewControllerNameSpace {
    // BottomSheetViewController
    /// 0.4
    static let backgroundColorAlpha: CGFloat = 0.4
    
    // BottomSheetView
    /// 20.0
    static let bottomSheetViewCornerRadius: CGFloat = 20.0
    /// 0.3
    static let bottomSheetViewAnimateDuration: CGFloat = 0.3
    /// 0.0
    static let bottomSheetViewAnimateDelay: CGFloat = 0.0
    
    // Garbber
    /// 2.5
    static let garbberCornerRadius: CGFloat = garbberHeight / 2
    /// 16.0
    static let garbberTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    /// 52.0
    static let garbberWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 13.86
    /// 5.0
    static let garbberHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.61
}
