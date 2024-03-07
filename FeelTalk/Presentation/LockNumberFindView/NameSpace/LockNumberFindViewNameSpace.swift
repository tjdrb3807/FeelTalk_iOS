//
//  LockNumberFindViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/16.
//

import Foundation

enum LockNumberFindViewNameSpace {
    // MARK: LockNumberFindView
    /// 0.4
    static let backgroundColorAlpha: CGFloat = 0.4
    
    // MARK: BottomSheet
    /// 20.0
    static let bottomSheetCornerRadius: CGFloat = 20.0
    /// 414.0
    static let bottomSheetTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 50.98
    /// 0.3
    static let bottomSheetAnimateDuration: CGFloat = 0.3
    /// 0.0
    static let bottomSheetAnimateDelay: CGFloat = 0.0
    
    // MARK: DismissButton
    /// "icon_x_mark_black"
    static let dismissButtonImage: String = "icon_x_mark_black"
    /// 20.0
    static let dismissButtonTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46
    /// 12.0
    static let dismissButtonLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 48.0
    static let dismissButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.8
    /// 48.0
    static let dismissButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.91
    
    // MARK: TitleLabel
    /// "아래의 방법으로\n비밀번호를 재설정할 수 있어요"
    static let titleLabelText: String = """
                                         아래의 방법으로
                                         비밀번호를 재설정할 수 있어요
                                         """
    /// 20.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 0
    static let titleLabelNumberOfLines: Int = 0
    /// 30.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69
    /// 78.0
    static let titlaLabelTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 9.60
    
    // MARK: PartnerRequestButton
    /// 158.0
    static let partnerRequestButtonTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.45
    
    // MARK: SendEmailButton
    /// 12.0
    static let sendEmailButtonTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    
}
