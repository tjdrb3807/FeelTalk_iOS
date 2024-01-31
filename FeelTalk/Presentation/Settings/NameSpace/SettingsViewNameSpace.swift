//
//  SettingsViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/29.
//

import Foundation

enum SettingsViewNameSpace {
    // MARK: TableView
    /// 0.0
    static let tableViewSeparatorTopInset: CGFloat = 0.0
    /// 0.0
    static let tableViewSeparatorLeftInset: CGFloat = 0.0
    /// 0.0
    static let tableViewSeparatorBottomInset: CGFloat = 0.0
    /// 0.0
    static let tableViewSeparatorRightInset: CGFloat = 0.0
    /// 0.0
    static let tableViewSectionFooterHeight: CGFloat = 0.0
    /// 8.0
    static let tableViewSectionHeaderHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98
    
    // MARK: LogOutButton
    static let logOutButtonTitle: String = "로그아웃"
    /// -28.0
    static let logOutButtonBottomOffset: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 3.44)
    /// 48.0
    static let logOutButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8
    /// 21.0
    static let logOutButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
}
