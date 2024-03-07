//
//  NumberPadViewCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum NumberPadViewCellNameSpace {
    // MARK: NumberPadViewCell
    /// "NumberPadViewCell"
    static let identifier: String = "NumberPadViewCell"
    /// 70.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 8.62
    
    // MARK: TitleLabel
    /// 20.0
    static let titleLabelNumberTypeTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 16.0
    static let titleLabelFunctionTypeTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
}
