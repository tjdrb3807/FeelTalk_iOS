//
//  MyPageViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/14.
//

import Foundation

enum MyPageViewNameSpace {
    // MARK: TableView
    static let tableViewCornerRadius: CGFloat = 16.0
    static let tableViewSeparatorTopInset: CGFloat = 0.0
    static let tableViewSeparatorLeftInset: CGFloat = 0.0
    static let tableViewSeparatorBottomInset: CGFloat = 0.0
    static let tableViewSeparatorRightInset: CGFloat = 0.0
    static let tableViewTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46       // 20.0
    static let tableViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2   // 12.0
    static let tableViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2  // 12.0
    static let tableViewBottomOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 21.67   // 176.0
}
