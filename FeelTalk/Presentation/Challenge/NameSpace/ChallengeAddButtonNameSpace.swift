//
//  ChallengeAddButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/26.
//

import Foundation

enum ChallengeAddButtonNameSpace {
    // ChallengeAddButton
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 40.0                      // 150.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.28                       // 51.0
    static let cornerRadius: CGFloat = height / 2
    static let shadowCornerRadius: CGFloat = 500
    static let shadowColorAlpha: CGFloat = 0.16
    static let shadowOpacity: Float = 1.0
    static let shadowRadius: CGFloat = 10.0
    static let shadowOffsetWidth: CGFloat = 0.0
    static let shadowOffsetHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49           // 4.0
    static let bottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 12.93                 // 105.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06    // 4.0
    
    // DescriptionLabel
    static let descriptionLabelText: String = "챌린지 추가"
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8    // 18.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.32   // 27.0
    
    // PlusImageView
    static let plusImageViewImage: String = "icon_plus_white"
}
