//
//  SettingsCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/29.
//

import Foundation

enum SettingsCellNameSpace {
    // MARK: SettingsCell
    static let identifier: String = "SettingsCell"
    /// 56.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
    
    // MARK: TitleLabel
    /// 16.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    
    // MARK: StateLabel
    /// 16.0
    static let stateLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    
    // MARK: ArrowIcon
    /// "icon_arrow_right"
    static let arrowIconImage: String = "icon_arrow_right"
}
