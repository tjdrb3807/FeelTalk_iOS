//
//  AdultAuthViewControllerNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/12.
//

import Foundation

enum AdultAuthViewControllerNameSpace {
    // MARK: ProgressBar
    /// 1 / 3
    static let ProgressBarPersentage: CGFloat = 1 / 3
    
    // MARK: TitleLabel
    static let titleLabelText: String = """
                                        서비스 이용을 위해
                                        인증 정보를 입력해 주세요.
                                        """
    /// 0
    static let titleLabelNumberOfLines: Int = 0
    /// 24.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4
    /// 36.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43
    /// 28.0
    static let titleLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.44
    
    // MARK: ScrollView
    /// 16.0
    static let scrollViewTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    
    // MARK: ContentStackView
    /// 12.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    
    // MARK: NameInputView
    static let nameInputViewPlaceholer: String = "이름"
    /// 56.0
    static let nameInputViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
    
    // MARK: FirstSpacingView
    /// 85.0
    static let firstSpacingViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 10.46
    
    // MARK: CompleteButton
    static let completeButtonTitleText: String = "인증완료"
    /// 18.0
    static let completeButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 29.5
    static let completeButtonCornerRadius: CGFloat = completeButtonHeight / 2
    /// 59.0
    static let completeButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26
    
    // MARK: SecondSpacingView
    /// 64.0
    static let secondSpacingViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.88
}
