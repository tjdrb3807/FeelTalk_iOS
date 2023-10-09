//
//  MyPageViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/14.
//

import Foundation

enum MyPageViewNameSpace {
    // MyPageView
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26            // 1.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47  // 12.0
    
    // TopSpacingView
    static let topSpacingViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98     // 8.0
    
    // TableView
    static let tableViewCornerRadius: CGFloat = 16.0
    static let tableViewSeparatorTopInset: CGFloat = 0.0
    static let tableViewSeparatorLeftInset: CGFloat = 0.0
    static let tableViewSeparatorBottomInset: CGFloat = 0.0
    static let tableViewSeparatorRightInset: CGFloat = 0.0
    static let tableViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2   // 12.0
    static let tableViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2  // 12.0
    static let tableViewBottomOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 21.67   // 176.0
}
