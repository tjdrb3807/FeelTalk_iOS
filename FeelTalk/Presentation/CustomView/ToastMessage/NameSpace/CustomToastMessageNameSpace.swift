//
//  CustomToastMessageNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/10.
//

import Foundation

enum CustomToastMessageNameSpace {
    // MARK: CustomToastMessage
    /// 12.0
    static let leadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 12.0
    static let trailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 56.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
    /// 0.7
    static let backgroundColorAlpha: CGFloat = 0.7
    /// 16.0
    static let cornerRadius: CGFloat = 16.0
    /// 16.0
    static let shadowPathCornerRadius: CGFloat = 16.0
    /// 0.16
    static let shadowColorAlpha: CGFloat = 0.16
    /// 1.0
    static let shadowOpacity: Float = 1.0
    /// 10.0
    static let shadowRadius: CGFloat = 10.0
    /// 0.0
    static let shadowOffsetWidth: CGFloat = 0.0
    /// 4.0
    static let shadowOffsetHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    /// -56.0
    static let bottomInset: CGFloat = -height
    static let updateBottomInset: CGFloat = Utils.safeAreaBottomInset() + (CommonConstraintNameSpace.verticalRatioCalculator * 1.47)
    
    
    
    // MARK: Message
    /// 16.0
    static let messageLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
}
