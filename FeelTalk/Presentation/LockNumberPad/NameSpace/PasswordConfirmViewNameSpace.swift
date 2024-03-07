//
//  PasswordConfirmViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum PasswordConfirmViewNameSpace {
    // MARK: PasswordConfirmView
    /// 28.0
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 7.46
    /// 164.0
    static let width: CGFloat = (PasswordConfirmViewCellNameSpace.width * 4) + (spacing * 3)
    /// 28.0
    static let height: CGFloat = PasswordConfirmViewCellNameSpace.height
}
