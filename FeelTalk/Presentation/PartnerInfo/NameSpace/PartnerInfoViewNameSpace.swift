//
//  PartnerInfoViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import Foundation

enum PartnerInfoViewNameSpcae {
    // PartnerInfoView
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26                     // 1.0
    static let cornerRadius: CGFloat = 16.0
    static let shadowRedColor: CGFloat = 0.0
    static let shadowGreenColor: CGFloat = 0.0
    static let shadowBlueColor: CGFloat = 0.0
    static let shadowColorAlpha: CGFloat = 0.02
    static let shadowOffsetWidth: CGFloat = 0.0
    static let shadowOffsetHeight: CGFloat = 0.0
    static let shadowOpacity: Float = 1.0
    static let shadowRadius: CGFloat = 12.0
    static let leadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                     // 12.0
    static let trailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                    // 12.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 11.82                           // 96.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98           // 8.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46          // 20.0
    static let contentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26    // 16.0
    static let contentStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26   // 16.0
    
    // DescriptionLabel
    static let descriptionLabelText: String = "나의 연인"
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2         // 12.0
    static let descriptionLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21            // 18.0
    
    // NicknameStackView
    static let nicknameStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06        // 4.0
    
    // NicknameLabel
    static let nicknameLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33           // 20.0
    static let nicknameLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69               // 30.0
}
