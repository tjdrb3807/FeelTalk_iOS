//
//  ChallengeCompleteBottomSheetViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/25.
//

import Foundation

enum ChallengeCompleteBottomSheetViewNameSpace {
    // MARK: BottomSheet
    /// 471.0
    static let bottomSheetTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 58.00
    /// 20.0
    static let bottomSheetCornerRadius: CGFloat = 20.0
    /// 20.0
    static let bottomSheetShadowCornerRadius: CGFloat = 20.0
    /// 0.04
    static let bottomSheetShadowColorAlpha: CGFloat = 0.04
    /// 1.0
    static let bottomSheetShadowOpacity: Float = 1.0
    /// 20.0
    static let bottomSheetShadowRadius: CGFloat = 20.0
    /// 0.0
    static let bottomSheetShadowOffsetWidth: CGFloat = 0.0
    /// -5.0
    static let bottomSheetShadowOffsetHeight: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 0.61)
    
    // MARK: Image
    static let image: String = "image_complete_challenge"
    /// 20.0
    static let imageTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46
    /// 150.0
    static let imageWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 40.0
    /// 150.0
    static let imageHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 18.47
    
    // MARK: HeaderLabel
    static let headerLabelText: String = "챌린지 성공 👏"
    /// 20.0
    static let headerLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33
    /// 30.0
    static let headerLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69
    
    // MARK: BodyLabel
    static let bodyLabelText: String = "기대하던 챌린지를 완료했어요."
    /// 16.0
    static let bodyLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 24.0
    static let bodyLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    /// 4.0
    static let bodyLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    
    // MARK: ConfirmButton
    static let confirmButtonTitleText: String = "우린 진짜 최고야 !"
    /// 18.0
    static let confirmButtonTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 29.5
    static let confirmButtonCornerRadius: CGFloat = confirmButtonHeight / 2
    /// 59.0
    static let confirmButtonHeight: CGFloat =  CommonConstraintNameSpace.verticalRatioCalculator * 7.26
    /// 20.0
    static let confirmButtonTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46
}
