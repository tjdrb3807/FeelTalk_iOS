//
//  SignalDialViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/23.
//

import Foundation

enum SignalDialViweNameSpace {
    // SignalDialView
    static let topInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 33.62                             // 273.0
    static let leadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 9.06                        // 34.0
    static let trailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 9.33                       // 35.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 29.92                               // 243.0
    
    // DialImageView
    static let dialImageViewImage: String = "image_dial"
    static let dialImageViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 9.06           // 34.0
    static let dialImageViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 9.33          // 35.0
    static let dialImageViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.21              // 18.0
    
    // SignalImageView
    static let signalImageViewCornerRadius: CGFloat = signalImageViewHeight / 2
    static let signalImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 43.2                // 162.0
    static let signalImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.95                // 162.0
    static let siganlImageViewSexyTypeImage: String = "image_signal_sexy"
    static let siganlImageViewLoveTypeImage: String = "image_signal_love"
    static let siganlImageViewAmbiguousTypeImage: String = "image_signal_ambiguous"
    static let siganlImageViewRefuseTypeImage: String = "image_signal_refuse"
    static let siganlImageViewTiredTypeImage: String = "image_signal_tired"
    
    // Pointer
    static let pointerSexyTypeImage: String = "image_pointer_sexy"
    static let pointerLoveTypeImage: String = "image_pointer_love"
    static let pointerAmbiguousTypeImage: String = "image_pointer_ambiguous"
    static let pointerRefuseTypeImage: String = "image_pointer_refuse"
    static let pointerTiredTypeImage: String = "image_pointer_tired"
    static let pointerWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4                         // 24.0
    static let pointerHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95                         // 24.0
    static let pointerSexyTypeTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 22.04             // 179.0
    static let pointerSexyTypeLeadingOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 62.93       // 236.0
    static let pointerLoveTypeTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 10.46             // 85.0
    static let pointerLoveTypeLeadingOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 61.6        // 231.0
    static let pointerAmbiguousTypeTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.94         // 32.0
    static let pointerRefuseTypeTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 10.46           // 85.0
    static let pointerRefuseTypeLeadingOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 13.86     // 52.0
    static let pointerTiredTypeTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 22.04            // 179.0
    static let pointerTiredTypeLeadingOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 12.53      // 47.0
    
}
