//
//  AlertViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/08.
//

import UIKit

enum AlertViewNameSpace {
    // MARK: AlertView
    static let backgroundAlpha: CGFloat = 0.4
    
    // MARK: ContentView
    static let contentViewCornerRadius: CGFloat = 20.0
    static let contentViewTopOffSet: CGFloat = -((UIScreen.main.bounds.height / 100) * 3.60)    // -30.0
    static let contentViewLeadingOffset: CGFloat = -((UIScreen.main.bounds.width / 100) * 8.0)  // -30.0
    static let contentViewTrailingOffset: CGFloat = (UIScreen.main.bounds.width / 100) * 8.0    // 30.0
    static let contentViewBottomOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 3.60    // 30.0
    static let contentViewCenterYInset: CGFloat = -((UIScreen.main.bounds.height / 100) * 0.61) // -5
    
    // MARK: ContentStackView
    static let contentStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 2.46    // 20.0
    static let contentStackViewWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 64.0       // 240.0
    
    // MARK: LabelStackView
    static let labelStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.24      // 2.0
    
    // MARK: TitleLabel
    static let titleLabelCancelAnswerTypeText: String = "답변 작성을 그만두시겠어요?"
    static let titleLabelSendAnswerTypeText: String = "답변을 보내시겠어요?"
    static let titleLabelNumberOfLines: Int = 1
    static let titleLabelTextFont: String = "pretendard-medium"
    static let titleLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.8           // 18.0
    static let titleLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 3.32           // 37.0
    
    // MARK: SubscriptLabel
    static let subscriptLabelCancelAnswerTypeText: String = "현재 작성한 내용은 삭제돼요."
    static let subscriptLabelSnedAnswerTypeText: String = """
                                                          작성한 답변을 상대방에게 보낼게요.
                                                          보낸 후에는 답변을 수정할 수 없어요.
                                                          """
    static let subscriptLabelNumberOfLines: Int = 0
    static let subscriptLabelTextFont: String = "pretendard-regular"
    static let subscriptLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.73      // 14.0
    static let subscriptLabelLineSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.15  // 1.25
    static let subscriptLabelPriority: CGFloat = 500.0
    
    // MARK: ButtonStackView
    static let buttonStackViewSpacing: CGFloat = (UIScreen.main.bounds.width / 100) * 2.13      // 8.0
    
    // MARK: Button
    static let buttonTitleTextFont: String = "pretendard-regular"
    static let buttonTitleTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26         // 16.0
    static let buttonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 5.91               // 48.0
    static let buttonCornerRadius: CGFloat = buttonHeight / 2
    
    // MARK: LeftButton
    static let leftButtonCancelAnswerTypeTitleText: String = "취소"
    static let leftButtonSendAnswerTypeTitleText: String = "취소"
    static let leftButtonBorderWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 0.26       // 1.0
    
    // MARK: RightButton
    static let rightButtonCancelAnswerTypeTitleText: String = "나가기"
    static let rightButtonSendAnswerTypeTitleText: String = "보내기"
    
}
