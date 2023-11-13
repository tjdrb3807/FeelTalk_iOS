//
//  HomeTodayQuestionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/19.
//

import Foundation

enum HomeTodayQuestionViewNameSpace {
    // HomeTodayQuestionView
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 38.42                      // 312.0
    static let cornerRadius: CGFloat = 20.0
    static let shadowRedColor: CGFloat = 0.0
    static let shadowGreenColor: CGFloat = 0.0
    static let shadowBlueColor: CGFloat = 0.0
    static let shadowColorAlpha: CGFloat = 0.08
    static let shadowOffsetWidth: CGFloat = 0.0
    static let shadowOffsetHeight: CGFloat = 0.0
    static let shadowOpacity: Float = 1.0
    static let shadowRadius: CGFloat = 8.0
    static let topOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 9.85                    // 80.0
    
    // ImageView
    static let imageViewImage: String = "image_home_question"
    static let imageViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 11.20           // 91.0
    static let iamgeViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 45.33     // 170.0
}
