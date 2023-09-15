//
//  ChallengeDetailTitleInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/22.
//

import UIKit

enum ChallengeDetailTitleInputViewNameSpace {
    // MARK: ChallengeDetailTitleInputView
    static let spacing: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33                     // 20.0
    static let height: CGFloat = (UIScreen.main.bounds.height / 100) * 9.60                     // 78.0
    
    // MARK: StackView
    static let stackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.49           // 4.0
    
    // MARK: DescriptionLabel
    static let descriptionLabelText: String = "챌린지명"
    static let desctiptionLabelTextColor: String = "gray_600"
    static let descriptionLabelTextFont: String = "pretendard-bold"
    static let descriptionLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2     // 12.0
    static let descriptionLabelLineHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 2.21 // 18.0
    
    // MARK: TextField
    static let textFieldTextFont: String = "pretendard-regular"
    static let textFieldTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26           // 16.0
    static let textFieldPlaceholder: String = "함께하고 싶은 챌린지를 작성해 주세요"
    static let textFieldPlaceholderColor: String = "gray_400"
    static let textFieldDefaultBackgroundColor: String = "gray_200"
    static let textFieldBorderWidth: CGFloat = 2.0
    static let textFieldCornerRadius: CGFloat = 12.0
    static let textFieldTintColor: String = "main_500"
    static let textFieldLeftPaddingWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2    // 12.0
    static let textFieldDefaultText: String = ""
    
    // MARK: TextCountingView
    static let textCountingViewDenominator: Int = 20
    
    // MARK: TextClearButton
    static let textClearButtonImage: String = "icon_text_clear"
    
    // MARK: SpacingView
    static let firstSpacingViewWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 1.06       // 4.0
    static let secondSpacingViewWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 1.06      // 4.0
    static let thridSpacingViewWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2        // 12.0
}
