//
//  MyPagePartnerInfoButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/09.
//

import UIKit

enum MyPagePartnerInfoButtonNameSpace {
    // MARK: MyPagePartnerInfoButton
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 10.83                              // 88
    
    // MARK: MyPagePartnerInfoView
    static let cornerRadius: CGFloat = 16.0
    
    // MARK: HorizontalStackView
    static let horizontalStakcViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2          // 12.0
    static let horizontalStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26    // 16.0
    
    // MARK: VerticalStackView
    static let verticalStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49             // 4.0
    
    // MARK: DescriptionStackView
    static let descriptionStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06        // 4.0
    static let descriptionStackViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58           // 21.0
    
    // MARK: DescriptionLable
    static let descriptionLabelText: String = "나의 연인"
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2            // 12.0
    
    // MARK: DescriptionImageView
    static let descriptionImageViewImage: String = "icon_user"
    static let descriptionImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26          // 16.0
    static let descriptionImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97           // 16.0
    
    // MARK: PartnerNicknameLabel
    static let partnerNicknameLabelDefaultText: String = "UserName님과 함께하고 있어요"
    static let partnerNicknameLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73       // 14.0
    static let partnerNicknameLabelTextLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95   // 24.0
    
    // MARK: RightArrowImageView
    static let rightArrowImageViewImage: String = "icon_right_arrow_pink"
}
