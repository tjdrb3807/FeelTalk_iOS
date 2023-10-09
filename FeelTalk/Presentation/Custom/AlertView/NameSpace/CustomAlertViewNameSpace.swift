//
//  CustomAlertViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/25.
//

import Foundation

enum CustomAlertViewNameSpace {
    // MARK: CustomAlertView
    static let backgroundColorAlpha: CGFloat = 0.4
    static let popUpAnimatDuration: CGFloat = 0.2
    static let animateDelay: CGFloat = 0.0
    static let dampingAnimateDuration: CGFloat = 0.5
    static let dampingAnimateSpring: CGFloat = 0.76
    static let dampingAnimateVelocity: CGFloat = 0.0
    
    // MARK: ContentView
    static let contentViewCornerRadius: CGFloat = 20.0
    static let contentViewTopOffset: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 3.69)      // -30.0
    static let contentViewLeadingOffset: CGFloat = -(CommonConstraintNameSpace.horizontalRatioCalculaotr * 8)   // -30.0
    static let contentViewtrailingOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 8     // 30.0
    static let contentViewBottomOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97      // 16.0
    
    // MARK: ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46      // 20.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 43.22    // 351
    
    // MARK: LabelStackView
    static let labelStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98        // 8.0
    
    // MARK: TitleLabel
    static let titleLabelInquiryTypeText: String = "문의사항 작성을 그만두시겠어요?"
    static let titleLabelSuggestionTypeText: String = "질문 제안을 그만 두시겠어요?"
    static let titleLableBreakUpTypeText: String = "정말 연인을 끊으시겠어요?"
    static let titleLabelNumberOfLines: Int = 1
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8          // 18.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.32         // 27.0
    
    // MARK: DescriptionLabel
    static let descriptionLabelDeleteGuideText: String = "현재 작성한 내용은 삭제돼요."
    static let descriptionLabelBreakUpTypeText: String = "상대방과의 연결이 즉시 끊어집니다."
    static let descriptionLabelNumberOfLines: Int = 0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73   // 14.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58   // 21.0
    
    // MARK: ButtonStackView
    static let buttonStackViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.13     // 8.0
    static let buttonStackViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 64.0       // 24.0
    static let buttonStackViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.91        // 48
    
    // MARK: Button
    static let buttonCornerRadius: CGFloat = (CommonConstraintNameSpace.verticalRatioCalculator * 5.91) / 2     // 24
    
    // MARK: LeftButton
    static let leftButtonContinuingTitleText: String = "계속하기"
    static let leftButtonBreakUpTypeTitleText: String = "돌아가기"
    
    // MARK: RightButton
    static let rightButtonGetoutTitleText: String = "나가기"
    static let rightButtonBreakUpTypeTitleText: String = "연인끊기"
    
}
