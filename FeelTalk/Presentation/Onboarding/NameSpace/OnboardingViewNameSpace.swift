//
//  OnboardingViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/29.
//

import Foundation

enum OnboardingViewNameSpace {
    // Images
    static let firstImage: String = "image_onboarding_first"
    static let secondImage: String = "image_onboarding_second"
    static let thirdImage: String = "image_onboarding_third"
    
    // Logo
    static let logoImage: String = "logo_feeltalk_white"
    /// 48.0
    static let logoTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.91
    
    // PageConrol
    /// 29.0
    static let pageControlTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.57
    /// 6.0
    static let pageControlHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.73
    
    // ImageScrollView
    /// 269.0
    static let imageScrollViewTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 33.12
    /// 318.0
    static let imageScrollViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 39.16
    
    // StartButton
    static let startButtonTitleText: String = "지금 바로 시작하기"
    /// 18.0
    static let startButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 29.5
    static let startButtonCornerRadius: CGFloat = startButtonHeight / 2
    /// 99.0
    static let startButtonBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 12.19
    static let startButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26
}
