//
//  SignUpAdultAuthenticationDescriptionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/23.
//

import Foundation

enum SignUpAdultAuthenticationDescriptionViewNameSpace {
    // AdultAuthenticationDescriptionView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49                              // 4.0
    static let testAuthenticatedStatusWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 29.6       // 111.0
    static let testAuthenticatedStatusHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95        // 24.0
    static let testNonAuthenticatedStatusWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 89.33   // 335
    static let testNonAuthenticatedStatusHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.91     // 48.0
    
    // DescriptionLabel
    static let descriptionLabelDefaultText: String = """
                                                     필로우톡은 청소년 보호법에 의거하여
                                                     만 19세 미만 청소년들은 이용할 수 없습니다.
                                                     """
    static let descriptionCertificatedText: String = """
                                                     성인인증 완료
                                                     """
    static let descriptionLabelNumberOfLines: Int = 0
    static let desctiptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95           // 24.0
    
    // CheckIcon
    static let checkIconImage: String = "icon_check_green"
    static let checkIconWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33                     // 20.0
    static let checkIconHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46                      // 20.0
}
