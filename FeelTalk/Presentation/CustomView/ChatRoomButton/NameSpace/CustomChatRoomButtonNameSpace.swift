//
//  CustomChatRoomButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/02.
//

import Foundation

enum CustomChatRoomButtonNameSpace {
    // MARK: CustomChatRoomButton
    /// 0.0
    static let shadowRedColor: CGFloat = 0.0
    /// 0.0
    static let shadowGreenColor: CGFloat = 0.0
    /// 0.0
    static let shadowBlueColor: CGFloat = 0.0
    /// 0.1
    static let shadowColorAlpha: CGFloat = 0.1
    /// -1.0
    static let shadowOffsetWidth: CGFloat = -(CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.27)
    /// -1.0
    static let shadowOffsetHeight: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 0.12)
    /// 1.0
    static let shadowOpacity: Float = 1.0
    /// 10.0
    static let shadowRadius: CGFloat = 10.0
    /// 2.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.24
    
    // MARK: ProfileImageView
    static let profileImageViewImage: String = "image_default_profile"
    /// 2.0
    static let profileImageViewBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53
    /// 28.0
    static let profileImageViewCornerRadius: CGFloat = profileImageViewHeight / 2
    /// 56.0
    static let profileImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 14.93         
    /// 56.0
    static let profileImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
}
