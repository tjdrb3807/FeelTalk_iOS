//
//  HomeBottomSheetViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/25.
//

import Foundation

enum HomeBottomSheetViewNameSpace {
    // BottomSheet
    static let bottomSheetTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 58.0          // 471.0
    static let bottomSheetCornerRadius: CGFloat = 20.0
    static let bottomSheetShadowColorAlpha: CGFloat = 0.04
    static let bottomSheetShadowOpacity: Float = 1.0
    static let bottomSheetOffsetWidth: CGFloat = 0.0
    static let bottomSheetOffsetHeight: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 0.61)   // -5.0
    static let bottomSheetTopPanGesturePrevnetionNumber: CGFloat = 0.0
    static let bottomSheetAnimateDuration: CGFloat = 0.3
    static let bottomSheetAnimateDelay: CGFloat = 0.0
    static let bottomSheetHiddenStateLocation: CGFloat = 4.0
    
    // TitleImageView
    static let titleImageViewImage: String = "image_home_signal_bottom_sheet"
    static let titleImageViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46       // 20.0
    static let titleImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 40.0        // 150.0
    static let titleImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 18.47        // 150.0
    
    // TitleLabel
    static let titleLabelText: String = "시그널 전송 완료 💓"
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33         // 20.0
    static let titleLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69             // 30.0
    
    // DescriptionLabel
    static let descriptionLabelText: String = "연인에게 시그널을 성공적으로 보냈어요."
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26   // 16.0
    static let descriptionLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49    // 4.0
    static let descriptionLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95       // 24.0
    
    // ConfirmButton
    static let confirmButtonTitleText: String = "확인"
    static let confirmButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8  // 18.0
    static let confirmButtonTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46       // 20.0
    static let confirmButtonCornerRadius: CGFloat = confirmButtonHeight / 2
    static let confirmButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26          // 59.0
}
