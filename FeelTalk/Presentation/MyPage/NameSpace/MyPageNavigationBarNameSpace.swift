//
//  MyPageNavigationBarNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/14.
//

import Foundation

enum MyPageNavigationBarNameSpace {
    // MARK: MyPageNavigationBar
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38                   // 60.0
    
    // MARK: TitleLabel
    static let titleLabelText: String = "마이페이지"
    static let titleLAbelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8      // 18.0
    
    // MARK: PushConfigurationSettingsButton
    static let pushConfigurationSettingsButtonIamge: String = "icon_my_page_gear"
    
    // MARK: Separator
    static let separatorBackgroundColorRed: CGFloat = 0.0
    static let separatorBackgroundColorGreen: CGFloat = 0.0
    static let separatorBackgroundColorBlue: CGFloat = 0.0
    static let separatorBackgroundColorAlpha: CGFloat = 0.08
    static let separatorTopOffset: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 0.12)    // 1.0
}
