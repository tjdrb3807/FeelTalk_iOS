//
//  ChatRecordingViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/13.
//

import Foundation

enum ChatRecordingViewNameSpace {
    // ChatRecordingView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47                  // 12.0
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 71.2                  // 267.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.91                   // 48.0
    
    // LeadingSpacing
    static let leadingSpacingWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26    // 16.0
    
    // PlayButton
    static let playButtonWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 10.66       // 40.0
    
    // ContentStackView
    static let contentStackViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.91   // 24.0
    static let contentStackViewFirstSubViewIndex: Int = 0
    static let contentStackViewSecondSubViewIndex: Int = 1
    
    // EqulizerView
    static let equlizerViewSpacing: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.8     // 3.0
    static let equlizerBarZeroCount: Int = 0
    static let recordingEqulizerBarCount: Int = 33
    static let playEqulizerBarCount: Int = 29
    
    // MiddleSpacing
    static let middleSpacingWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66     // 10.0
    
    // TimeLabel
    static let timeLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.7       // 14.0
    
    // TrailingSpcing
    static let trailingSpacingWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.6    // 6.0
}
