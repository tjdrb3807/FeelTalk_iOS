//
//  ChatInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/11.
//

import Foundation

enum ChatInputViewNameSapce {
    // ChatInputView
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 8.12                                               // 66.0
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.10                                              // 9.0
    static let shadowPathCornerRadius: CGFloat = 0.0
    static let shadowRedColor: CGFloat = 0.0
    static let shadowGreenColor: CGFloat = 0.0
    static let shadowBlueColor: CGFloat = 0.0
    static let shadowColorAlpha: CGFloat = 0.08
    static let shadowOpacity: Float = 1.0
    static let shadowRadius: CGFloat = 1.0
    static let shadowOffsetWidth: CGFloat = 0.0
    static let shadowOffsetHeight: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 0.12)                                // -1.0
    
    
    // ContentStackView
    static let contentStackViewCornerRadius: CGFloat = (CommonConstraintNameSpace.verticalRatioCalculator * 5.91) / 3
    static let contentStackViewBorderWitth : CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26                       // 1.0
    static let contentStackViewFirstSubviewIndex: Int = 0
    
    // FunctionButton
    static let functionButtonImage: String = "icon_plus"
    static let functionButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8                                // 48.0
    static let functionButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.88                                 // 48.0
    
    // InputButton
    static let inputButtonImageViewHorizontalInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.6                 // 6.0
    static let inputButtonImageViewVertivalInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.73                    // 6.0
    static let inputButtonImageViewCornerRadius: CGFloat = (CommonConstraintNameSpace.verticalRatioCalculator * 4.43) / 2               // 18.0
    static let inputButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8                                   // 48.0
    static let inputButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.88                                    // 48.0
    static let inputButtonRecodingDisableModeImage: String = "icon_recoding_disable"
    static let inputButtonRecodingAbleModeImage: String = "icon_recoding_able"
    static let inputButtonStopRecodingModeImage: String = "icon_recoding_stop"
    static let imputButtonSendRecodingModeImage: String = "icon_recoding_send"
    static let imputButtonSendMessageModeImage: String = "icon_message_send"
    
    // TrailingSpacing
    static let trailingSpacingWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                                // 12.0
}
