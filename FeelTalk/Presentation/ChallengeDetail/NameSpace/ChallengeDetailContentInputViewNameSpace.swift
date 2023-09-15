//
//  ChallengeDetailContentInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/24.
//

import UIKit

enum ChallengeDetailContentInputViewNameSpace {
    // MARK: ChallengeDetailContentInputViewNameSpace
    static let spacing: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33                             // 20.0
    
    // MARK: VerticalStackView
    static let verticalStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.49           // 4.0
    
    // MARK: DescriptionLabel
    static let descriptionLabelText: String = "챌린지 내용"
    static let desctiptionLabelTextColor: String = "gray_600"
    static let descriptionLabelTextFont: String = "pretendard-bold"
    static let descriptionLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2             // 12.0
    static let descriptionLabelLineHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 2.21         // 18.0
    
    // MARK: TextView
    static let textViewPlaceholder: String = "내용을 자세히 적어보세요 !"
    static let textViewPlaceholderColor: String = "gray_400"
    static let textViewTextFont: String = "pretendard-regular"
    static let textViewTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26                    // 16.0
    static let textViewDefaultBackgroundColor: String = "gray_200"
    static let textViewCornerRadius: CGFloat = 12.0
    static let textViewBorderWidth: CGFloat = 2.0
    static let textViewTintColor: String = "main_500"
    static let textViewTextContainerTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97      // 16.0
    static let textViewTextContainerLeftInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2       // 12.0
    static let textViewTextContainerBottomInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97   // 16.0
    static let textViewTextContainerRightInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2      // 12.0
    static let textViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 19.45                    // 158.0
    
    // MARK: CountingView
    static let countingViewDenominator: Int = 100
    static let countingViewTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 15.02              // 122
    static let countingViewTrailingOffset: CGFloat = -((UIScreen.main.bounds.width / 100) * 3.2)        // -12.0
}
