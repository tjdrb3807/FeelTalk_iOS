//
//  CustomTitleViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import Foundation

enum CustomTitleViewNameSpace {
    // MARK: CustomTitlaView
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53                        // 2.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58                           // 21.0
    
    // MARK: LeadingSpacingView
    static let leadingSpacingViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53        // 2.0
    
    // MARK: TitleLabel
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73             // 14.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58             // 21.0
    
    // MARK: EssentialMarkImgaeView
    static let essentialMarkImageViewImage: String = "icon_essential_mark"
    static let essentialMarkImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.04    // 7.65
    static let essentialMarkImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.97     // 7.94
}
