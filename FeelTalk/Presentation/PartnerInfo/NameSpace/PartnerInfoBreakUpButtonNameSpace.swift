//
//  PartnerInfoBreakUpButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import Foundation

enum PartnerInfoBreakUpButtonNameSpace {
    // PartnerInfoBreakUpButton
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26                    // 1.0
    static let cornerRadius: CGFloat = 16.0
    static let leadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                    // 12.0
    static let trailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                   // 12.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.88                           // 64.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06        // 4.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49         // 4.0
    static let contentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.13   // 8.0
    static let conetntStackViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49      // 4.0
    
    // RightImageView
    static let rightImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8            // 48.0
    static let rightImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator *  5.91            // 48.0
    
    // BreakUpLabel
    static let breakUpLabelText: String = "연인끊기"
    static let breakUpLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26           // 16.0
}
