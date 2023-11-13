//
//  ChallengeDetailDeadlineInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/23.
//

import UIKit

enum ChallengeDetailDeadlineInputViewNameSpace {
    // MARK: ChallengeDetailDeadlineInputView
    static let spacing: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33                          // 20.0
    static let height: CGFloat = (UIScreen.main.bounds.height / 100) * 9.97                          // 81.0
    
    // MARK: VerticalStackView
    static let verticalStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.49        // 4.0
    
    // MARK: DescriptionLabel
    static let descriptionLabelText: String = "챌린지 마감일"
    static let descriptionLabelTextColor: String = "gray_600"
    static let desctiptionLabelTextFont: String = "pretendard-bold"
    static let descriptionLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2          // 12.0
    static let descriptionLabelLineHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 2.21      // 18.0
    
    // MARK: StackView
    static let stackViewSpacing: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2                  // 12.0
    
    // MARK: DeadlineTextField
    static let deadlineTextFieldTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26            // 16.0
    static let deadlineTextFiedlDefaultBackgroundColor: String = "gray_200"
    static let deadlineTextFieldCornerRadius: CGFloat = 12.0
    static let deadlineTextFieldLeftPaddingWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2     // 12.0
    static let deadlineTextFieldBorderWidth: CGFloat = 2.0
    
    // MARK: CalenderImageView
    static let calenderImageViewImage: String = "icon_calender"
    static let calenderImageViewWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 12.8           // 48.0
    static let calenderImageViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 5.91         // 48.0
    
    // MARK: DdayLable
    static let dDayLabelDefaultText: String = "D-day"
    static let dDayLabelTextColor: String = "main_500"
    static let dDayLabelNumberOfLines: Int = 1
    static let dDayLabelTextFont: String = "pretendard-medium"
    static let dDayLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26                // 16.0
    static let dDayLabelBackgroundColor: String = "main_300"
    static let dDayLabelCornerRadius: CGFloat = 12.0
    static let dDayLabelWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 22.66                  // 85.0
    static let dDayLabelWidthPriority: Int = 1000
    
    // MARK: DatePicker
    static let datePickerLocaleIdentifier: String = "ko-KR"
}
