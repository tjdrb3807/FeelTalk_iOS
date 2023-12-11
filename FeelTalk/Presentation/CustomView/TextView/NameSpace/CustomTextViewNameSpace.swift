//
//  CustomTextViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/25.
//

import Foundation

enum CustomTextViewNameSpace {
    // MARK: TextView
    static let textViewTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26                   // 16.0
    static let textViewBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53                // 2.0
    static let textViewCornerRadius: CGFloat = 12.0
    static let textViewTextContainerTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97        // 16.0
    static let textViewTextContainerLeftInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2      // 12.0
    static let textViewTextContainerBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.66     // 46.0
    static let textViewTextContainerRightInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2     // 12.0
    
    // MARK: CountingView
    static let countingViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2           // 12.0
    static let countingViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97              // 16.0
}
