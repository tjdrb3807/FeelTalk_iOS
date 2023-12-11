//
//  ServiceTerminationStateTitleViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/06.
//

import Foundation

enum ServiceTerminationStateTitleViewNameSpace {
    // ServiceTerminationStateTitleView
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.13                    // 8,0
    
    // WarningImageView
    static let warningImageViewImage: String = "icon_warning_red"
    static let warningImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33      // 20.0
    
    // TitleMessageLabel
    static let titleMessageLabelBreakUpTypeText: String = "연인을 끊기 전 꼭 확인해주세요"
    static let titleMessageLabelWithdrawalTypeText: String = "탈퇴 전 꼭 확인해주세요"
    static let titleMessageLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26  // 16.0
}
