//
//  LockNumberOpenGraphNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/18.
//

import Foundation

enum LockNumberOpenGraphNameSpace {
    // MARK: LockNumberOpenGraph
    /// 250.0
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 66.66
    /// 266.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 32.75
    /// 16.0
    static let cornerRadius: CGFloat = 16.0
    
    // MARK: ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    
    // MARK: SOSImage
    /// "image_password_open_graph"
    static let sosImage: String = "image_password_open_graph"
    /// 84.0
    static let sosImageWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 22.4
    /// 84.0
    static let sosImageHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 10.34
    
    // MARK: LabelStackView
    /// 4.0
    static let labelStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.06
    
    // MARK: TitleLabel
    /// "연인이 도움을 요청했어요"
    static let titleLabelText: String = "연인이 도움을 요청했어요"
    /// 16.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 24.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    
    // MARK: DescriptionLabel
    /// "연인이 암호를 잃어버렸어요. 도와주기 버튼을\n누르면 연인이 암호를 재설정할 수 있어요."
    static let descriptionLabelText: String = """
                                               연인이 암호를 잃어버렸어요. 도와주기 버튼을
                                               누르면 연인이 암호를 재설정할 수 있어요.
                                               """
    /// 12.0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 0
    static let descriptionLabelNumberOfLines: Int = 0
    /// 18.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // MARK: WarningContentStackView
    /// 4.0
    static let warningContentStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06
    
    // MARK: WarningIcon
    /// "icon_warning_open_graph"
    static let warningIconImage: String = "icon_warning_open_graph"
    /// 14.0
    static let warningIconWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 14.0
    static let warningIconHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.72
    
    // MARK: WarningLabel
    /// "수락 전, 해킹에 유의해 주세요 !"
    static let warningLabelText: String = "수락 전, 해킹에 유의해 주세요 !"
    /// 12.0
    static let warningLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    /// 18.0
    static let warningLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21
    
    // MARK: HelpButton
    /// "도와주기"
    static let helpButtonTitleText: String = "도와주기"
    /// 16.0
    static let helpButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 20.0
    static let helpButtonCornerRadius: CGFloat = helpButtonHeight / 2
    /// 226.0
    static let helpButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 60.26
    /// 40.0
    static let helpButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.92
}
