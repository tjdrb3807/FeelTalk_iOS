//
//  CommonConstraintNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import UIKit

enum CommonConstraintNameSpace {
    // MARK: Layout
    static let horizontalRatioCalculaotr: CGFloat = UIScreen.main.bounds.width / 100
    static let verticalRatioCalculator: CGFloat = UIScreen.main.bounds.height / 100
    static let leadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33    // 20.0
    static let trailingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33   // 20.0
    
    // MARK: Button
    static let buttonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 5.91   // 48.0
    static let buttonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 12.8     // 48.0
}
