//
//  MyPageProfileViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/13.
//

import Foundation

enum MyPageProfileViewNameSpace {
    // MARK: MyPageProfileView
    static let borderWidth: CGFloat = 1.0
    static let cornerRadius: CGFloat = 16.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46                      // 20.0
    static let leadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                  // 12.0
    static let trailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                 // 12.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 28.32                        // 230.0
    
    // MARK: TotalStackView
    static let totalStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97          // 16.0
    static let totalStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46         // 20.0
    static let totalStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26   // 16.0
    static let totalStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26  // 16.0
    
    // MARK: MyProfileStackView
    static let myProfileStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26    // 16.0
    
    
    // MARK: MyNicknameStackView
    static let myNicknameStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06   // 4.0
    
    // MARK: MyNicknameLabel
    static let myNicknameLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33      // 20.0
    
    // MARK: SNSImageView
    static let appleLogoImage: String = "icon_my_page_apple"
    static let googleImage: String = "icon_my_page_google"
    static let kakaoImage: String = "icon_my_page_kakao"
    static let naverImage: String = "icon_my_page_naver"
}
