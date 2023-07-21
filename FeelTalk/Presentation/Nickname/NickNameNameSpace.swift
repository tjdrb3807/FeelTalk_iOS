//
//  NickNameNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/13.
//

import UIKit

enum NicknameNameSpace {
    static let baseLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
    static let baseTrailingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
    
    static let titleLabelText: String = "닉네임을 입력해주세요"
    static let titleLabelTextFont: String = "pretendard-medium"
    static let titleLabelTextSize: CGFloat = 24.0
    static let titleLabelTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 2.70
    static let titleLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 4.43
    
    static let descriptionLabelText: String = "여러분의 소중한 성생활이 노출되지 않도록 본명이 유추되지 않는 닉네임으로 설정해주세요."
    static let descriptionLabelTextColor: String = "gray_600"
    static let descriptionLabelTextFont: String = "pretendard-regular"
    static let descriptionLabelTextSize: CGFloat = 16.0
    static let descriptionLabelLineNumber: Int = 0
    static let descriptionLabelLineSpace: CGFloat = 5.0
    static let descriptionLabelTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 0.49
    static let descriptionLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 5.91
    
    static let nicknameLabelText: String = "닉네임"
    static let nicknameLabelTextFont: String = "pretendard-bold"
    static let nicknameLabelTextColor: String = "gray_500"
    static let nicknameLabelTextSize: CGFloat = 12.0
    static let nicknameTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 4.92
    
    static let nicknameTextFieldPlaceholder: String = "연인에게 보여줄 닉네임을 적어주세요"
    static let nicknameTextFieldBackgroundColor: String = "gray_200"
    static let nicknameTextFieldCornerRadius: CGFloat = 8.0
    static let nicknameTextFieldTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 0.98
    static let nicknameTextFieldHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 6.89
    
    static let nextButtonTitle: String = "다음"
    static let nextButtonTitleFont: String = "pretendard-medium"
    static let nextButtonTitleSize: CGFloat = 18.0
    static let nextButtonActiveBackgroundColor: String = "main_500"
    static let nextButtonDeactiveBackgoundColor: String = "main_400"
    static let nextButtonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 6.77
}
