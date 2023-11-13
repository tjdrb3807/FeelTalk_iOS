//
//  ChatNavigationBarNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import Foundation

enum ChatNavigationBarNameSpace {
    // ChatNavigationBar
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38                           // 60.0
    static let cornerRadius: CGFloat = 20.0
    static let shadowCornerRadius: CGFloat = 0.0
    static let shadowRedColor: CGFloat = 0.0
    static let shadowGreenColor: CGFloat = 0.0
    static let shadowBlueColor: CGFloat = 0.0
    static let shadowColorAlpha: CGFloat = 0.08
    static let shadowOpacity: Float = 1.0
    static let shadowRadius: CGFloat = 1.0
    static let shadowOffsetWidth: CGFloat = 0.0
    static let shadowOffsetHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.12               // 1.0
    
    // PartnerNicknameLabel
    static let partnerNicknameLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8    // 18.0
    
    // MenuButton
    static let menuButtonImage: String = "icon_chat_top_menu"
    static let menuButtonTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2         // 12.0
    
}
