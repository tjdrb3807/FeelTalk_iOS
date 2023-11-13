//
//  SignalPercentageViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/23.
//

import Foundation

enum SignalPercentageViewNameSpace {
    // SignalPercentageView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98                          // 8.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 8.74                           // 71.0
    static let topInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 20.44                        // 166.0
    
    // PercentageLabel
    static let percentageLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73        // 14.0
    static let percentableLabelBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26    // 1.0
    static let percentageLabelCornerRadius: CGFloat = percentageLabelHeight / 2
    static let percentableLabelWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 24.53         // 92.0
    static let percentageLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.06            // 33.0
    static let percentageLabelSexyTypeText: String = "시그널 100%"
    static let percentageLabelLoveTypeText: String = "시그널 75%"
    static let percentageLabelAmbiguousTypeText: String = "시그널 50%"
    static let percentageLabelRefuseTypeText: String = "시그널 25%"
    static let percentageLabelTiredTypeText: String = "시그널 0%"
    
    // DescriptoinLabel
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33       // 20.0
    static let descriptionLabelSexyTypeText: String = "나 오늘 준비됐어 !"
    static let descriptionLabelLoveTypeText: String = "오늘 사랑 충만 !"
    static let descriptionLabelAmbiguousTypeText: String = "나도 날 잘 모르겠어"
    static let descriptionLabelRefuseTypeText: String = "그럴 기분 아니야 !"
    static let descriptionLabelTiredTypeText: String = "오늘은 정말 피곤해.."
    static let descriptionLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69           // 30.0
}
