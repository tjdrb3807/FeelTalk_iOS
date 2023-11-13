//
//  ChatViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import Foundation

enum ChatViweNameSpace {
    // ChatView
    static let backgroundColorAlpha: CGFloat = 0.4
    
    // ChatRoomButton
    static let chatRoomButtonTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.24  // 2.0
    
    // ChatRoomView
    static let chatRoomViewCornerRadius: CGFloat = 20.0
    static let chatRoomViewTipStartX: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 81.86 // 307.0
    static let chatRoomViewTipStartY: CGFloat = 0.0
    static let chatRoomViewTipEndWidth: CGFloat = chatRoomViewTipStartX + chatRoomViewTipWidth
    static let chatRoomViewTipWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33   // 20.0
    static let chatRoomViewTipHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.23    // 10.0
    static let chatRoomViewTipThirdX: CGFloat = chatRoomViewTipEndWidth - (CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53)
    static let chatRoomViewTipThirdY: CGFloat = 0.0
    static let chatRoomViewTipFourthX: CGFloat = 0.0
    static let chatRoomViewTipFourthY: CGFloat = 0.0
    static let chatRoomViewTipInsertAt: UInt32 = 0
    static let chatRoomViewTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 9.48    // 77.0
}
