//
//  LoginLogoViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/21.
//

import Foundation

enum LoginLogoViewNameSpace {
    // LoginLogoView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97                      // 16.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 9.11                       // 74.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 16.74                   // 136.0
    
    // LogoImageView
    static let logoImageViewImage: String = "logo_feeltalk_white"
    static let logoImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 42.4         // 159.0
    static let logoImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.54          // 45.0
    
    // DescriptionLabel
    static let descriptionLabelText: String = "연인들의 건강하고 즐거운 대화"
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26   // 16.0
}
