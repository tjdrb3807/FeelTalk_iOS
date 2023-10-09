//
//  BreakUpViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/06.
//

import Foundation

enum BreakUpViewNameSpace {
    // TerminationStatementView
    static let terminationStatementViewTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 18.71   // 152.0
    static let terminationStatementViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 26.10      // 212.0
    
    // BreakDescriptionLabel
    static let breakUpDescriptionLabelText: String = """
                                                     아래 연인 끊기 버튼을 누르면
                                                     상대방과의 연결이 즉시 끊어지니 신중하게 결정해주세요.
                                                     """
    static let breakUpDescriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73    // 14.0
    static let breakUpDescriptionLabelNumberOfLines: Int = 0
    static let breakUpDescriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58    // 21.0
    static let breakUpDescriptionLabelHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 5.17        // 42.0
    static let breakUpDescriptionLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.92     // 40.0
}
