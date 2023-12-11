//
//  SignUpTitleViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/23.
//

import Foundation

enum SignUpTitleViewNameSpace {
    // TitleView
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 11.33                  // 92.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.09                // 17.0
    
    // TitleLabel
    static let titleLabelDefaultText: String = """
                                               필로우톡은 성인을 위한 공간으로
                                               성인인증 후 즐길 수 있어요
                                               """
    static let titleLabelCertificatedText: String = """
                                                    성인인증을 완료했어요.
                                                    필로우톡 이용약관에 동의해주세요
                                                    """
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4      // 24.0
    static let titleLabelNumberOfLines: Int = 0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43     // 36.0
}

