//
//  PasswordConfirmViewCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum PasswordConfirmViewCellNameSpace {
    // MARK: PasswordConfirmViewCell
    /// 12.0
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.72
    /// 20.0
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 28.0
    static let height: CGFloat = circleIconHeight + spacing + bottomBorderHeight
    
    // MARK: CircelIcon
    /// 6.0
    static let circleIconCornerRadius: CGFloat = circleIconHeight / 2
    /// 12.0
    static let circleIconWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 12.0
    static let circleIconHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    
    // MARK: BottomBorder
    /// 2.0
    static let bottomBorderHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.24
}
