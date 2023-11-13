//
//  TextChatCellNameSpcae.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/19.
//

import Foundation

enum TextChatCellNameSapce {
    // VerticalContentStackView
    static let verticalContentStckViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49   // 4.0
    
    // HorizontalContentStackView
    static let horizontalContentStackViewMyChatTypaSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06    // 4.0
    static let horizontalContentStackViewPartnerChatTypeSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.13   // 8.0
    
    // MessageTextViwe
    static let messageTextViewContainerTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.23 // 10.0
    static let messageTextViewContainerLeftInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26  // 16.0
    static let messageTextViewContainerBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.23  // 10.0
    static let messageTextViewContainerRightInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26 // 16.0
    static let messageTextViewMaxWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 69.33   // 260.0
    static let messageTextViewTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26    // 16.0
    static let messageTextViewCornerRadius: CGFloat = 16.0
}
