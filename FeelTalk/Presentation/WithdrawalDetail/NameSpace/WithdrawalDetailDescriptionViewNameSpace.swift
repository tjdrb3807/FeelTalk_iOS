//
//  WithdrawalDetailDescriptionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum WithdrawalDetailDescriptionViewNameSpace {
    // MARK: WithdrawalDetailDescriptionView
    /// 74.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 9.11
    
    // MARK: DescriptionLabel
    /// """
    /// 필로우톡 탈퇴하기 버튼을 누르면
    /// 계정이 삭제되니 꼭 신중하게 결정해주세요.
    /// """
    static let descriptionLabelText: String = """
                                               필로우톡 탈퇴하기 버튼을 누르면
                                               계정이 삭제되니 꼭 신중하게 결정해주세요.
                                               """
    /// 14.0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 0
    static let descriptionLabelNumberOfLines: Int = 0
    /// 21.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
}
