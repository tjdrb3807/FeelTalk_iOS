//
//  AdultAuthIDCardNumberInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/04.
//

import Foundation

enum AdultAuthIDCardNumberInputViewNameSpace {
    // AdultAuthIDCardNumberInputView
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89                                   // 56.0
    
    // AdultAuthIDCardNumberInputView
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2                                 // 12.0
    static let cornerRadius: CGFloat = 12.0
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53                            // 2.0
    
    // BirthdayInputTextField
    static let birthdayInputTextFieldPlaceholder: String = "생년월일 6자리"
    static let birthdayInputTextFieldTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26         // 16.0
    static let birthdayInputTextFieldPaddingViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2  // 12.0
    static let birthdayInputTextFieldWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 40.53           // 152.0
    static let birthdayInputTextFieldLimitCount: Int = 6
    
    // HyphenLabel
    static let hyphenLabelText: String = "-"
    static let hyphenLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26                    // 16.0
}
