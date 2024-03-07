//
//  LockNumberHintHeaderViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/08.
//

import Foundation

enum LockNumberHintHeaderViewNameSpace {
    // MARK: LockNumberHintHeaderView
    /// 20.0
    static let spacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    
    // MARK: ContentStackView
    /// 4.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    
    // MARK: TitleLabel
    /// 24.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4
    /// 0
    static let titleLabelNumberOfLines: Int = 0
    /// """암호를 잊어버렸을 때\n어떤 질문으로 찾으시겠어요?
    static let titleLabelSettingsTypeText: String = """
                                                     암호를 잊어버렸을 때
                                                     어떤 질문으로 찾으시겠어요?
                                                     """
    /// """본인인증 질문에 답변하면\n암호를 재설정할 수 있어요"""
    static let titleLabelResetTypeText: String = """
                                                  본인인증 질문에 답변하면
                                                  암호를 재설정할 수 있어요
                                                  """
    /// 36.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43
    
    // MARK: DescriptionLabel
    /// """질문을 선택하면 암호를 잊어버렸을 때\n암호를 빠르게 재설정할 수 있어요."""
    static let descriptionLabelText: String = """
                                               질문을 선택하면 암호를 잊어버렸을 때
                                               암호를 빠르게 재설정할 수 있어요.
                                               """
    /// 16.0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 0
    static let descriptionLabelNumberOfLines: Int = 0
    /// 24.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    
    // MARK: TopSpacing
    /// 28.0
    static let topSpacingHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.44
}
