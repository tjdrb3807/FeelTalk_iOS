//
//  LockNumberHintSelectionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/08.
//

import Foundation

enum LockNumberHintSelectionViewNameSpace {
    // MARK: LockNumberHintSelectionView
    /// 20.0
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 78.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 9.60
    
    // MARK: ContentStackView
    /// 4.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    
    // MARK: InputTitleView
    /// 18.0
    static let inputTitleViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // MARK: PickerButton
    /// 12.0
    static let pickerButtonCornerRadius: CGFloat = 12.0
    /// 2.0
    static let pickerButtonBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53
    /// 56.0
    static let pickerButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89
    
    // MARK: ButtonContentStackView
    /// 12.0
    static let buttonContentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    
    // MARK: SelectionHintLabel
    /// 16.0
    static let selectionHintLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    
    // MARK: ArrowIcon
    /// "icon_arrow_top_gary"
    static let arrowIconAbleTypeImage: String = "icon_arrow_top_gray"
    /// "icon_arrow_bottom_gray"
    static let arrowIconDisableTypeImage: String = "icon_arrow_bottom_gray"
    /// 48.0
    static let arrowIconWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8
    /// 48.0
    static let arrowIconHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.91
}
