//
//  LockNumberPadViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum LockNumberPadViewNameSpace {
    // MARK: TitleLabel
    /// 24.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4
    /// 160.0
    static let titleLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.70
    
    // MARK: DescriptionLabel
    /// 16.0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 0
    static let descriptionLabelNumberOfLines: Int = 0
    /// 12.0
    static let descriptionLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    /// 24.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    
    // MARK: HintButton
    /// "암호를 잊어버렸어요"
    static let hintButtonTitleText: String = "암호를 잊어버렸어요"
    /// 60.0
    static let hintButtonTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38
    /// 21.0
    static let hintButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
}
