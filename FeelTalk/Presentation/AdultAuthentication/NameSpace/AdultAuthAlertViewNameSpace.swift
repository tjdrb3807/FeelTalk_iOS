//
//  AdultAuthAlertViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/14.
//

import Foundation

enum AdultAuthAlertViewNameSpace {
    // MARK: AdultAuthAlertView
    /// 0.5
    static let animateDuration: CGFloat = 0.5
    /// 0.0
    static let animateDelay: CGFloat = 0.0
    /// 0.4
    static let backgroundColorAlpha: CGFloat = 0.4
    /// 0.76
    static let damping: CGFloat = 0.76
    /// 0.0
    static let springVelocity: CGFloat = 0.0
    
    // MARK: ContentView
    /// 20.0
    static let contentViewCornerRadius: CGFloat = 20.0
    /// -30.0
    static let contentViewTopOffset: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 3.69)
    /// -30.0
    static let contentViewLeadingOffset: CGFloat = -(CommonConstraintNameSpace.horizontalRatioCalculaotr * 8.0)
    /// 30.0
    static let contentViewTrailingOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 8.0
    /// -30.0
    static let contentViewBottomOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69
    
    // MARK: ContentStackView
    /// 20.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46
    /// 351.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 43.22
    
    // MARK: LabelStackView
    /// 8.0
    static let labelStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98
    
    // MARK: TitleLabel
    static let titleLabelText: String = "개인정보가 올바르지 않아요"
    /// 18.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 27.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.32
    
    // MARK: DescriptionLabel
    static let descriptionLabelText: String = "입력하신 정보를 다시 확인해 주세요."
    /// 14.0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 21.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
    
    // MARK: CheckButton
    static let checkButtonTitleText: String = "확인"
    /// 16.0
    static let checkButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 24.0
    static let checkButtonCornerRadius: CGFloat = checkButtonHeight / 2
    /// 240.0
    static let checkButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 64.0
    /// 48.0
    static let checkButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.91
    
}
