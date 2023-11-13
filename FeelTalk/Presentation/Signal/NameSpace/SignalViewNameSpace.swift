//
//  SignalViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/23.
//

import Foundation

enum SignalViewNameSpace {
    // SignalView
    static let backgrouneColorAlpha: CGFloat = 0.4
    
    // BottomSheetView
    static let bottomSheetViewCornerRadius: CGFloat = 20.0
    static let bottomSheetViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 20.07         // 163.0
    static let bottomSheetAnimateDuration: CGFloat = 0.3
    static let bottomSheetAnimageDelay: CGFloat = 0.0
    
    // Garbber
    static let garbberCornerRadius: CGFloat = garbberHeight / 2
    static let garbberTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97                  // 16.0
    static let garbberWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 13.86                  // 52.0
    static let garbberHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.61                    // 5.0
    
    // DescriptionLabel
    static let descriptionLabelText: String = """
                                              오늘 내 기분을
                                              연인에게 보내봐요 !
                                              """
    static let descriptionLabelNumberOfLines: Int = 0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4        // 24.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43       // 36.0
    static let descriptionLabelTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.03         // 49.0
    
    // ChangeSignalButton
    static let changeSignalButtonTitleText: String = "시그널 바꾸기"
    static let changeSignalButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8 // 18.0
    static let changeSignalButtonCornerRadius: CGFloat = changeSignalButtonHeight / 2
    static let changeSignalButtonTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 68.47      // 556.0
    static let changeSignalButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26         // 59.0
}
