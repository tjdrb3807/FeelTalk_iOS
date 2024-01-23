//
//  EmptyChallengeViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/20.
//

import Foundation

enum EmptyChallengeViewNameSpace {
    // MARK: EmptyChallengeView
    /// 10.0
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.23
    /// 182.0
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 48.53
    /// 233.0
    static let height: CGFloat = imageHeight + spacing + headerLabelLineHeight + labelStackViewSpacing + bodyLabelLineHeihgt + bodyLabelLineHeihgt
    /// 72.0
    static let topInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 8.86
    
    // MARK: ImageView
    static let image = "image_empty_challenge"
    /// 150.0
    static let imageWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 40.0
    /// 150.0
    static let imageHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 18.47
    
    // MARK: LabelStackView
    /// 4.0
    static let labelStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    
    // MARK: HeaderLabel
    /// 18.0
    static let headerLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 27.0
    static let headerLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.32
    static let headerLabelOngoingStateText: String = "진행중인 챌린지가 없어요"
    static let headerLabelCompletedStateText: String = "완료된 챌린지가 없어요"
    
    // MARK: BodyLabel
    static let bodyLabelText: String = """
                                       연인과 함께 챌린지를 만들고
                                       서로의 취향에 대해 더 알아가봐요
                                       """
    /// 14.0
    static let bodyLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.7
    /// 21.0
    static let bodyLabelLineHeihgt: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
    /// 2
    static let bodyLabelNumberOfLines: Int = 2
}
