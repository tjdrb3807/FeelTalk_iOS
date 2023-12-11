//
//  SignUpFullInfoSelectionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/24.
//

import Foundation

enum SignUpFullInfoSelectionViewNameSpace {
    // SignUpFullInfoSelectionView
    static let cornerRadius: CGFloat = 12.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.88                           // 64.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2         // 12.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46         // 20.0
    static let contentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2    // 12.0
    static let contentStakcViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2   // 12.0
    static let contentStackViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46      // 20.0
    
    // FullSelectionButton
    static let fullSelectionButtonImage: String = "icon_full_selection"
    
    // ContentLabel
    static let contentLabelText: String = "약관 및 개인, 민감정보 수집, 이용 동의"
    static let contentLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26           // 16.0
    
    // PresentDetailViewButton
    static let presentDetailViewButtonImage: String = "icon_right_arrow"
    static let presentDetailViewButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4    // 24.0
}
