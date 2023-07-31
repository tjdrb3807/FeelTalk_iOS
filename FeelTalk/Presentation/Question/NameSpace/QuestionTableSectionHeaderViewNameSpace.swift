//
//  QuestionTableSectionHeaderViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/30.
//

import SnapKit

enum QuestionTableSectionHeaderViewNameSpace {
    // MARK: QuestionTableSectionHeaderView
    static let height: CGFloat = (UIScreen.main.bounds.height / 100) * 7.38 // 60
    static let identifier: String = "QuestionTableSectionHeaderView"
    
    // MARK: TitleLabel
    static let titleLabelText: String = "우리가 나눈 필로우톡"
    static let titleLabelTextFont: String = "pretendard-medium"
    static let titleLabelTextSize: CGFloat = (UIScreen.main.bounds.width / 100) * 4.8 // 18
    static let titleLabelLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33 // 20
}
