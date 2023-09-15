//
//  ChallengeDetailToolbarNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/25.
//

import UIKit

enum ChallengeDetailToolbarNameSpace {
    // MARK: Toolbar
    static let height: CGFloat = (UIScreen.main.bounds.height / 100) * 6.77                             // 55.0
    
    // MARK: Separator
    static let separatorBackgroundColor: String = "gray_400"
    static let separatorHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 0.12                    // 1.0
    
    // MARK: RecommendationLabel
    static let recommendationLabelText: String = "추천"
    static let recommendationLabelTextColor: String = "gray_500"
    static let recommendationLabelTextFont: String = "pretendard-regular"
    static let recommendationLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.73         // 14.0
    static let recommnedationLabelLineHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 2.58      // 21.0
    static let recommendationLabelBorderColor: String = "gray_500"
    static let recommendationLabelBorderWidth: CGFloat = 1.0
    static let recommendationLabelCorderRadius: CGFloat = recommendationLabelHeight / 2
    static let recommendationLabelLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2      // 12.0
    static let recommendationLabelWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 10.93           // 41.0
    static let recommendationLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 3.57          // 29.0
    
    // MARK: BannerCollectionView
    static let bannerCollectionViewLineSpacing: CGFloat = 0.0
    static let bannerCollectionViewItemSpacing: CGFloat = 0.0
    static let bannerCollectionViewLeadingOffset: CGFloat = (UIScreen.main.bounds.width / 100) * 1.6    // 6.0
    static let bannerCollectionViewTrailingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 10.4   // 39.0
    static let bannerCollectionViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 4.31         // 35.0
    
    // MARK: NextButton
    static let nextButtonTitleDefaultText: String = "다음"
    static let nextButtonTitleContentTypeText: String = "완료"
    static let nextButtonTitleTextColor: String = "main_500"
    static let nextButtonTitleTextFont: String = "pretendard-medium"
    static let nextButtonTitleTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.8              // 18.0
}
