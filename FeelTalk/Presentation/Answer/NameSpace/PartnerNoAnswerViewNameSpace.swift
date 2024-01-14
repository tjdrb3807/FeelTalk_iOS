//
//  PartnerNoAnswerViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/03.
//

import UIKit

enum PartnerNoAnswerViewNameSpace {
    // MARK: PartnerNoAnswerView
    static let cornerRadius: CGFloat = 12.0
    /// 159.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.58
    
    // MARK: ContentStackView
    /// 10.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.23
    
    // MARK: TitleLabel
    static let titleLabelText: String = "연인이 아직 답변을 작성하지 않았어요 😢"
    /// 16.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 24.0
    static let titleLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    
    // MARK: AnswerChaseUpButton
    static let answerChaseUpButtonTitleText: String = "콕 찔러서 답변 요청하기"
    /// 20.0
    static let answerCuaseUpButtonCornerRadius: CGFloat = answerChaseUpButotnHeight / 2
    /// 16.0
    static let answerChaseUpButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 173.0
    static let answerChaseUpButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 46.13
    /// 40.0
    static let answerChaseUpButotnHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.28
}
