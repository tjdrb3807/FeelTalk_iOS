//
//  OnboardingTitleViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/01.
//

import Foundation

enum OnboardingTitleViewNameSpace {
    // OnboardingTitleView
    /// 4.0
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    /// 76.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 9.35
    /// 155.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.08
    
    // TitleLabel
    static let titleLabelFirstText: String = "오늘 내 상태는 말이야"
    static let titleLabelSecondText: String = "너의 취향이 궁금해!"
    static let titleLabelThirdText: String = "우리 좀 더 가까워져 볼까?"
    /// 20.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    static let titleLabelNumberOfLines: Int = 1
    
    // DescriptionLabel
    static let descriptionLabelFirstText: String = """
                                                   귀여운 필롱이로 연인에게
                                                   오늘의 시그널을 보낼 수 있어요!
                                                   """
    static let descriptionLabelSecondText: String = """
                                                    하루에 하나, 질문에 답변해 보세요.
                                                    서로의 취향에 더 가까워질 거예요.
                                                    """
    static let descriptionLabelThirdText: String = """
                                                   더 진솔한 대화를 나눠보세요.
                                                   연인의 가장 깊은 곳을 알게 될 거예요.
                                                   """
    /// 14.0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    static let descriptionLabelNumberOfLines: Int = 2
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
}
