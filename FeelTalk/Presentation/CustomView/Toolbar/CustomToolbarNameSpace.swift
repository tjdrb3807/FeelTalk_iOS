//
//  CustomToolbarNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/25.
//

import Foundation

enum CustomToolbarNameSpace {
    // MARK: CustomToolbar
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.77                       // 55.0
    
    // MARK: RightButton
    static let rightButtonOngoingTypeText: String = "다음"
    static let rightButtonCompletionTypeText: String = "완료"
    static let tightButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8    // 18.0
    
    // MARK: Separator
    static let separatorHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.12              // 1.0
}
