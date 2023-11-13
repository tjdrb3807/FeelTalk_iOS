//
//  SignalDialPointButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/24.
//

import Foundation

enum SignalDialPointButtonNameSpace {
    // SignalDialPointButton
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 21.86                             // 82.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 10.09                              // 82.0
    static let zeroTypeLeadingOffset: CGFloat = -(CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8)            // -18.0
    static let zeroTypeBottomOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.57                 // 29.0
    static let twentyTypeLeadingOffset: CGFloat = -(CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.13)         // -8.0
    static let twentyTypeBottomOffset: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 13.42)           // -109.0
    static let fiftyTypeTopOffset: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 3.81)                // -31.0
    static let seventyFiveTypeBottomOffset: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 13.42)      // -109.0
    static let seventyFiveTypeTrailingOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.13      // 8.0
    static let hundredTypeTrailingOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8           // 18.0
    static let hundredTypeBottomOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.57              // 29.0
    
    // Point
    static let pointBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26                   // 1.0
    static let pointCornerRadius: CGFloat = pointHeight / 2
    static let pointWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                          // 12.0
    static let pointHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47                          // 12.0
}
