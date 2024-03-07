//
//  SignalOpenGraphNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/16.
//

import Foundation

enum SignalOpenGraphNameSpace {
    // MARK: SignalOpenGraph
    /// 250.0
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 67.46
    /// 230.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 28.32
    /// 16.0
    static let cornerRadius: CGFloat = 16.0
    
    // MARK: ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47
    
    // MARK: TitleLabel
    /// """
    /// 두근두근 💘
    /// 연인이 시그널을 보냈어요
    /// """
    static let titleLabelText: String = """
                                         두근두근 💘
                                         연인이 시그널을 보냈어요
                                         """
    /// 16.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 0
    static let titleLabelNumberOfLines: Int = 0
    /// 24.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    
    // MARK: SignalImage
    /// "image_signal_small_sexy"
    static let signalImageSexyType: String = "image_signal_small_sexy"
    /// "image_signal_small_love"
    static let signalImageLoveType: String = "image_signal_small_love"
    /// "image_signal_small_ambiguous"
    static let signalImageAmbiguousType: String = "image_signal_small_ambiguous"
    /// "image_signal_small_refuse"
    static let signalImageRefuseType: String = "image_signal_small_refuse"
    /// "image_signal_small_tired"
    static let signalImageTiredType: String = "image_signal_small_tired"
    
    // MARK: SignalLabel
    /// 16.0
    static let signalLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 24.0
    static let signalLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    /// "나 오늘 준비됐어 !"
    static let signalLabelSexyTypeText: String = "나 오늘 준비됐어 !"
    /// "오늘 사랑 충만 !"
    static let signalLabelLoveTypeText: String = "오늘 사랑 충만 !"
    /// "나도 날 잘 모르겠어"
    static let signalLabelAmbiguousTypeText: String = "나도 날 잘 모르겠어"
    /// "그럴 기분 아니야 !"
    static let signalLabelRefuseTypeText: String = "그럴 기분 아니야 !"
    /// "오늘은 정말 피곤해.."
    static let signalLabelTiredTypeText: String = "오늘은 정말 피곤해.."
}
