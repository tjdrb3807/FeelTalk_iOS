//
//  ServiceTerminatinoStatementConfirmButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/06.
//

import Foundation

enum ServiceTerminatinoStatementConfirmButtonNameSpace {
    // ServiceTerminatinoStatementConfirmButton
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.88                            // 64.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2          // 12.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46          // 20.0
    static let contentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2     // 12.0
    static let contentStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2    // 12.0
    static let contentStackViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46       // 20.0
    
    // CheckImageView
    static let checkImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4              // 24.0
    static let checkImageViewAbleIamge: String = "icon_circle_check_able"
    static let checkImageViewDisableImage: String = "icon_circle_check_unable"
    
    // DescriptionLabel
    static let descriptionLabelText: String = "내용을 모두 확인했습니다."
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26        // 16.0
}
