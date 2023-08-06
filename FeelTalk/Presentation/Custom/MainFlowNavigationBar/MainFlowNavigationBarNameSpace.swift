//
//  MainFlowNavigationBarNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/29.
//

import UIKit

enum MainFlowNavigationBarNameSpace {
    // MARK: MainFlowNavigationBar
    static let baseHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.38 // 60
    static let updateHeight: CGFloat = 0.0
    static let navigationBarQuestionTypeBackgrountColor: String = "gray_100"
    static let animateDuration: CGFloat = 0.2
    static let scrollVelocityCriteria: CGFloat = 0.0
    
    // MARK: TitleLabel
    static let titleLableQuestionTypeText: String = "질문"
    static let titleLabelTextFont: String = "pretendard-medium"
    static let titleLabelTextSize: CGFloat = 18.0
    static let titleLabelLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33 // 20
    
    // MARK: ButtonContainerView
    static let buttonContainerViewShadowOffsetWidth: CGFloat = 2.0
    static let buttonContainerViewShadowOffestHeight: CGFloat = 2.0
    static let buttonContainerViewShadowColorRed: CGFloat = 0.0
    static let buttonContainerViewShadowColorGreen: CGFloat = 0.0
    static let buttonContainerViewShadowColorBlue: CGFloat = 0.0
    static let buttonContainerViewShadowColorAlpha: CGFloat = 0.08
    static let buttonContainerViewShadowOpacity: Float = 1.0
    static let buttonContainerViewShadowRadius: CGFloat = 10.0
    static let buttonContainerViewTrailingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33 // 20
    static let buttonbuttonContainerViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 6.89 // 56
    
    
    // MARK: ChatRoomButton
    static let chatRoomButtonBackgroundImage: String = "image_default_profile"
    static let chatRoomButtonBackgroundColor: String = "main_500"
    static let chatRoomButtonBorderWidth: CGFloat = 3.0
    static let chatRoomButtonCornerRadius: CGFloat = buttonbuttonContainerViewHeight / 2
 
    // MARK: Shadow
    static let shadowOffsetWidth: CGFloat = 0.0
    static let shadowOffsetHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 0.12  // 1
    static let shadowColorRed: CGFloat = 0.0
    static let shadowColorGreen: CGFloat = 0.0
    static let shadowColorBlue: CGFloat = 0.0
    static let shadowColorAlpha: CGFloat = 0.08
    static let shadowOpacity: Float = 1.0
    static let shadowRadius: CGFloat = 1.0
}
