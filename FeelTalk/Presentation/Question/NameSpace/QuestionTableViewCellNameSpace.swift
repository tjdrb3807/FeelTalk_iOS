//
//  QuestionTableViewCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/29.
//

import UIKit

enum QuestionTableViewCellNameSpace {
    // MARK: QuestionListViewCell
    static let backgroundColor: String = "gray_100"
    static let cornerRadius: CGFloat = 16.0
    static let topEdegeInset: CGFloat = 0.0
    /// 12.0
    static let leftEdegeInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    static let bottomEdegeInset: CGFloat = (UIScreen.main.bounds.height / 100) * 0.98  // 8
    /// 12.0
    static let rightEdegeInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2
    static let hegith: CGFloat = (UIScreen.main.bounds.height / 100) * 8.37 // 68
    static let identifier: String = "QuestionTableViewCell"
    
    // MARK: IndexLabel
    static let indexLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 3.73 // 14
    static let indexLabelBackgroundColor: String = "gray_200"
    static let indexLabelCornerRadius: CGFloat = 15.0
    static let indexLabelLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2  // 12
    static let indexLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 5.41  // 44
    
    // MARK: QuestionBodyLabel
    static let questionBodyLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.26 // 16
    static let questionBodyLabelLeadingOffset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2  // 12
}
