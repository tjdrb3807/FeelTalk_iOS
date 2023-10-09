//
//  LockingPasswordDisplayViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/20.
//

import Foundation

enum LockingPasswordDisplayViewNameSpace {
    // MARK: LockingPasswordDisplayView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38                      // 60.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.70                   // 160.0
    
    // MARK: LabelStackView
    static let labelStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47        // 12.0
    
    // MARK: TitleLabel
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4          // 24.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43         // 36.0
    static let titleLabelSettingsModeText: String = "암호설정"
    static let titleLabelChangeModeText: String = "암호변경"
    
    // MARK: DescriptionLabel
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26   // 16.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95   // 24.0
    static let descriptionLabelSettingsModeText: String = "사용하고자 하는 암호를 입력해주세요."
    static let descriptionLabelChangeModeText: String = "새로운 암호를 입력해주세요."
}
