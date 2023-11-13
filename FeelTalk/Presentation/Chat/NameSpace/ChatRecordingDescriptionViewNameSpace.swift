//
//  ChatRecordingDescriptionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/13.
//

import Foundation

enum ChatRecordingDescriptionViewNameSpace {
    // ChatRecordingDescriptionView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47                      // 12.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2     // 12.0
    static let contentStackViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.91       // 24.0
    
    // DescriptionLabel
    static let descriptionLableText: String = "연인에게 음성메세지를 보내보세요 !"
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73   // 14.0
}
