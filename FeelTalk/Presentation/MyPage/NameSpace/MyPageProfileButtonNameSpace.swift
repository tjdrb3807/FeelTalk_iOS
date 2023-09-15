//
//  MyPageProfileButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/13.
//

import Foundation

enum MyPageProfileButtonNameSpace {
    // MARK: ProfileImageView
    static let profileImageViewBorderWidth: CGFloat = 2.0
    static let profileImageViewCornerRadius: CGFloat = profileImageViewHeight / 2
    static let profileImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 22.93 // 86.0
    static let profileImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 10.59  // 86.0
    
    // MARK: ModifyImageView
    static let modifyImageViewImage: String = "icon_my_page_profile"
    static let modifyImageViewCornerRadius: CGFloat = modifyImageViewHeight / 2
    static let modifyImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 8.53   // 32.0
    static let modifyImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.92    // 32.0
    
}
