//
//  HomeTodaySignalButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/21.
//

import Foundation

enum HomeTodaySignalButtonNameSpace {
    // HomeTodaySignalButton
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 35.77                          // 134.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 21.55                           // 175.0
    static let topInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.29                          // 43.0
    static let cornerRadius: CGFloat = 16.0
    static let shadowColorAlpha: CGFloat = 0.08
    static let shadowOffsetWidth: CGFloat = 0.0
    static let shadowOffsetHeight: CGFloat = 0.0
    static let shadowOpacity: Float = 1.0
    static let shadowRadius: CGFloat = 8.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98           // 8.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97          // 16.0
    static let contentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26    // 16.0
    static let contentStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26   // 16.0
    
    // SignalImageView
    static let signalImageViewCornerRadius: CGFloat = signalImageViewHeight / 2
    static let signalImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 12.56            // 102.0
    static let signalImageViewSexyTypeImage: String = "image_signal_small_sexy"
    static let signalImageViewLoveTypeImage: String = "image_signal_small_love"
    static let signalImageViewAmbiguousTypeImage: String = "image_signal_small_ambiguous"
    static let signalImageViewRefuseTypeImage: String = "image_signal_small_refuse"
    static let signalImageViewTiredTypeImage: String = "image_signal_small_tired"
    
    // TargetLabel
    static let targetLabelMyTypeWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 9.86          // 37.0
    static let targetLabelPartnerTypeWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 16.26    // 61
    static let targetLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73             // 14.0
    static let targetLabelCornerRadius: CGFloat = targetLabelHeight / 2
    static let targetLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.06                 // 33.0
}
