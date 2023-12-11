//
//  SignalOpenGraphNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/16.
//

import Foundation

enum SignalOpenGraphNameSpace {
    static let width: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 66.66 // 250.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 38.91  // 316.0
    static let cornerRadius: CGFloat = 16.0
    
    // TotlaStackView
    static let totalStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97    // 16.0
    static let totalStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97    // 16.0
    static let totalStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2  // 12.0
    static let totalStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2    // 12.0
    static let totalStackViewBottomInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.97    // 16.0
    
    // TitleLabel
    static let titleLabelText: String = """
                                        두근두근 💘
                                        연인이 시그널을 보냈어요
                                        """
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26 // 16.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95 // 24.0
    static let titleLabelNumberOfLines: Int = 2
    
    // ContentView
    static let contentViewCornerRadius: CGFloat = 12.0
    
    // ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47  // 12.0
    static let contentStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47 // 12.0
    static let contentStackViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66   // 10.0
    static let contentStackViewTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.66   // 10.0
    
    // SubContentStackView
    static let subContentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.98   // 8.0
    
    // PercentLabel
    static let percentLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2    // 12.0
    static let percentLabelBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26    // 1.0
    static let percentLabelWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 13.86 // 52.0
    static let percentLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.20   // 26.0
    static let percentLabelCornerRadius: CGFloat = percentLabelHeight / 2
    
    // DescriptionLabel
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26   // 16.0
    static let descriptionLAbelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95   // 24.0
}
