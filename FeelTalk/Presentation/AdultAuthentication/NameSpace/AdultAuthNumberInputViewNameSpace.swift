//
//  AdultAuthNumberInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/05.
//

import Foundation

enum AdultAuthNumberInputViewNameSpace {
    // AdultAuthNumberInputView
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53                    // 2.0
    static let cornerRadius: CGFloat = 12.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.98                           // 56.0
    
    // AuthNumberInputView
    static let authNumberInputViewTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26    // 16.0
    static let authNumberInputViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98      // 8.0
    static let authNumberInputViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2 // 12.0
    static let authNumberInputViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98   // 8.0
    
    // AuthButton
    static let authButtonTitleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26   // 16.0
    static let authButtonBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26          // 1.0
    static let authButtonCornerRadius: CGFloat = authButtonHeight / 2
    static let authButtonTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2         // 12.0
    static let authButtonDefaultWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 23.2         // 87.0
    static let authButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.92                 // 40.0
}
