//
//  SettingListCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/09.
//

import Foundation

enum SettingListCellNameSpace {
    // SettingListCell
    static let identifier: String = "SettingListCell"
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.98                               // 56.0
    
    // TitleLabel
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26                 // 16.0
    
    // StateLabel
    static let stateLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26                 // 16.0
    static let stateLabelTrailingOffset: CGFloat = -(CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2)         //-12.0
    
    // RightArrowIcon
    static let rightArrowIconImage: String = "icon_right_arrow"
    static let rightArrowIconImageTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2    // 12.0
    static let rightArrowIconWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4                 // 24.0
    
}
