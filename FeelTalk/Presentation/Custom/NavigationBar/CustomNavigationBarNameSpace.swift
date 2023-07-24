//
//  CustomNavigationBarNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/24.
//

import UIKit

enum CustomNavigationBarNameSpace {
    // MARK: NavigationBar
    static let navigationBarHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.38
    
    // MARK: LeftButton
    static let leftButtonSignUpTypeImage: String = "icon_x_mark_black"
    static let leftButtonInviteCodeTypeImage: String = "icon_left_arrow_black"
    static let leftButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 12.8
    
    // MARK: TitieLabel
    static let titleLabelSignUpTypeText: String = "회원가입"
    static let titleLabelInviteCodeTypeText: String = "연인코드 연결"
    static let titleLabelTextFont: String = "pretendard-medium"
    static let titleLabelTextSize: CGFloat = 18.0
    
}
