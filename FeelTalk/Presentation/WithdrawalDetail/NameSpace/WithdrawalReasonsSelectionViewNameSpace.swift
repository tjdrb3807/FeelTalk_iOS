//
//  WithdrawalReasonsSelectionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum WithdrawalReasonsSelectionViewNameSpace {
    // MARK: WithdrawalReasonsSelectionView
    /// 20.0
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 296.0
    static let height: CGFloat = (
        topSpacingHeight + contentStackViewSpacing + headerStackViewHeight + contentStackViewSpacing +
        WithdrawalReasonCellNameSpace.defaultHeight + WithdrawalReasonCellNameSpace.defaultHeight +
        WithdrawalReasonCellNameSpace.defaultHeight + WithdrawalReasonCellNameSpace.defaultHeight +
        cellStackViewSpacing + cellStackViewSpacing + cellStackViewSpacing
    )
    
    // MARK: ContentStackView
    /// 8.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98
    
    // MARK: TopSpacing
    /// 20.0
    static let topSpacingHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46
    
    // MARK: HeaderStackView
    /// 2.0
    static let headerStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53
    /// 21.0
    static let headerStackViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
    
    // MARK: HeaderLabel
    /// "탈퇴 사유"
    static let headerLabelText: String = "탈퇴 사유"
    /// 14.0
    static let headerLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 21.0
    static let headerLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
    
    // MARK: AsteriskIcon
    /// "icon_essential_mark"
    static let asteriskIconImage: String = "icon_essential_mark"
    
    // MARK: CellStackView
    /// 5.0
    static let cellStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.61
}
