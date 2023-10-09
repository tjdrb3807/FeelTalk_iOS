//
//  SuggestionsEmailInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/26.
//

import Foundation

enum SuggestionsEmailInputViewNameSpace {
    // MARK: SuggestionsEmailInputView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47                                   // 12.0
    
    // MARK: EmailInputTextField
    static let emailInputTextFieldTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26             // 16.0
    static let emailInputTextFieldBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53          // 2.0
    static let emailInputTextFieldCornerRadius: CGFloat = 12.0
    static let emailInputTextFieldLeftPaddingViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.28 // 12.0
    static let emailInputTextFieldClearButtonImage: String = "icon_text_clear"
    static let emailInputTextFieldPlaceholderText: String = "이메일"
}
