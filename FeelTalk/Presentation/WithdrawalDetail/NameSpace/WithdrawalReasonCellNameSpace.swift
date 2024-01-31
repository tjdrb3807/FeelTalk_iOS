//
//  WithdrawalReasonCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum WithdrawalReasonCellNameSpace {
    // MARK: WithdrawalReasonCell
    /// 190.0
    static let updateHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 23.39
    /// 56.0
    static let defaultHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
    /// 1.0
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26
    /// 12.0
    static let cornerRadius: CGFloat = 12.0
    
    // MARK: ContentStackView
    /// 12.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    /// 12.0
    static let contentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 12.0
    static let contentStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 16.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97
    
    // MARK: HeaderStackView
    /// 12.0
    static let headerStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    
    // MARK: CheckIcon
    /// "icon_circle_check_able"
    static let checkIconSelectedImage: String = "icon_circle_check_able"
    /// "icon_circle_check_unable"
    static let checkIconUnselectedImage: String = "icon_circle_check_unable"
    /// 24.0
    static let checkIconWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4
    /// 24.0
    static let checkIconHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    
    // MARK: TitleLabel
    /// 16.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 24.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    
    // MARK: ReasonInputTextView
    /// "기타 사유를 입력해주세요."
    static let reasonInputTextViewPlaceholder: String = "기타 사유를 입력해주세요."
    /// 50
    static let reasonInputTextViewMaxCount: Int = 50
    /// 310.0
    static let reasonInputTextViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 82.66
    /// 0.0
    static let reasonInputTextViewDefaultHeight: CGFloat = 0.0
    /// 122.0
    static let reasonInputTextViewUpdateHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 15.02
}
