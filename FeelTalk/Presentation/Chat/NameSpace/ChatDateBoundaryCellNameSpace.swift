//
//  ChatDateBoundaryCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/20.
//

import Foundation

enum ChatDateBoundaryCellNameSpace {
    // ContentView
    static let contentViewTopInset: CGFloat = 0.0
    static let contentViewLeftInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66       // 10.0
    static let contentViewBottomInset: CGFloat = 0.0
    static let contentViewRightInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66      // 10.0
    
    // DateLabel
    static let dateLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2           // 12.0
    
    // LeftLine
    static let leftLineLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66       // 10.0
    static let leftLineTrailingOffset: CGFloat = -(CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66)  // -10.0
    static let leftLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.12               // 1.0
    
    // RightLine
    static let rightLineLeadingOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66     // 10.0
    static let rightLineTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66     // 10.0
    static let rightLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.12              // 1.0
    
}
