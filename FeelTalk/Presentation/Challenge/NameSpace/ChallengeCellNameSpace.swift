//
//  ChallengeCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/17.
//

import UIKit

enum ChallengeCellNameSpace {
    // MARK: Cell
    static let backgroundColor: String = "gray_200"

    // MARK: ContentView
    static let contentViewCornerRadius: CGFloat = 20.0
    static let contentViewWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 42.66                       // 160.0
    static let contentViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 22.29                     // 181.0
    
    
    // MARK: TotalStackView
    static let totalStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.98                  // 8.0
    static let totalStackViewTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97                // 16.0
    static let totalStackViewLeadingOffset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33             // 20.0
    static let totalStackViewTrailingOffset: CGFloat = -((UIScreen.main.bounds.width / 100) * 5.33)         // -20.0
    
    // MARK: TopStackView
    static let topStackViewSpaing: CGFloat = (UIScreen.main.bounds.width / 100) * 8.53                      // 32.0
    static let topStackViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 3.94                     // 32.0
    
    // MARK: CategoryImgaeView
    static let categoryImageViewBackgroundColor: String = "gray_200"
    static let categoryImageViewCornerRadius: CGFloat = 8.0
    static let categoryImageViewWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 8.53                  // 32.0
    
    // MARK: DdayLabel
    static let dDayLabelTextFont: String = "pretendard-regular"
    static let dDayLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2                        // 12.0
    static let dDayLabelBackgroundColor: String = "gray_200"
    static let dDayLabelCornerRadius: CGFloat = dDayLabelHeight / 2
    static let dDayLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 3.94                        // 32.0
    
    // MARK: MiddleStackView
    static let middleStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.49                 // 4.0
    
    // MARK: TitleLabel
    static let titleLabelTextFont: String = "pretendard-bold"
    static let titleLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26                      // 16.0
    static let titleLabelLineSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.15                  // 1.25
    static let titleLabelLineHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 2.95                   // 24.0
    static let titleLabelNumberOfLines: Int = 0
    
    // MARK: CreatorNameLabel
    static let creatorNameLabelTextColor: String = "gray_600"
    static let creatorNameLabelTextFont: String = "pretendard-regular"
    static let creatorNameLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.73                // 14.0
    static let creatorNameLabelLineHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 2.58             // 21.0
    static let creatorNameLabelNumberOfLines: Int = 1
    
    // MARK: ChallengeCompletedButton
    static let challengeCompletedButtonImage: String = "icon_challenge_check"
    static let challengeCompletedButtonBackgroundColor: String = "gray_100"
    static let challengeCompletedButtonBorderWidth: CGFloat = 1.0
    static let challengeCompletedButtonBorderColor: String = "gray_300"
    static let challengeCompletedButtonCornerRadius: CGFloat = challengeCompletedButtonHeight / 2
    static let challengeCompletedButtonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 4.43         // 36.0
    static let challengeCompletedButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 9.6            // 36.0
    static let challengeCompletedButtonBottomOffset: CGFloat = -(UIScreen.main.bounds.height / 100) * 1.97  // -16.0
}
