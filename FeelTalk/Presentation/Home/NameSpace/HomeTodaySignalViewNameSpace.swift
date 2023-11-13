//
//  HomeTodaySignalViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/21.
//

import Foundation

enum HomeTodaySignalViewNameSpace {
    // HomeTodaySignalView
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.94                    // 32.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 26.72                      // 217.0
    
    // TitleLabel
    static let titleLabelText: String = "오늘의 시그널"
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33         // 20.0
    static let titleLAbelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69         // 30.0
    
    // HeartImageView
    static let heartImageViewImage: String = "image_home_heart"
    static let heartImageViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 8.37       // 68
    static let heartImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 40.0        // 150.0
    static let heartImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 16.74        // 126.0
    
    // FrequencyImageView
    static let frequencyImageViewImage: String = "image_home_frequency"
    static let frequencyImageViewTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.41  // 44.0
    static let frequencyImageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 22.93   // 86
    static let frequencyImageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43     // 36.0
}
