//
//  SignUpAdultAuthenticationViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/23.
//

import Foundation

enum SignUpAdultAuthenticationViewNameSpace {
    // SignUpAdultAuthenticationView
    static let authenticatedStatusSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21                   // 18.0
    static let nonAuthenticatedStatusSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46                // 20.0
    static let nonAuthenticatedStatusTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.66              // 46.0
    static let testNonAuthenticatedStatusHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 51.23            // 416.0
    static let testAuthenticatedStatusHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 27.46               // 223.0
    
    // TitleImageView
    static let titleImageViewAuthenticatedStatusImage: String = "image_id_card_success"
    static let titleImageViewNonAuthenticatedStatusImage: String = "image_id_card_default"
    static let titleImageViewAuthenticatedStatusWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 68.8     // 258.0
    static let titleImageViewAuthenticatedStatusHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator
    * 23.52 // 191.0
    static let titleImageViewNonAuthenticatedStatusHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 33.12  // 269
    
    // DescriptionLabel
    
    // AuthButton
    static let authButtonTitleText: String = "성인인증 하기"
    static let authButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8                     // 18.0
    static let authButtonCornerRadius: CGFloat = authButtonHeight / 2
    static let authButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26                             // 59.0
}
