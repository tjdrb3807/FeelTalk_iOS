//
//  MyPageTableViewCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/14.
//

import Foundation

enum MyPageTableViewCellNameSpace {
    // MARK: MyPageTableViewCell
    static let identifier: String = "MyPageTableViewCell"
    static let defaultCellIndex: Int = 1
    static let defaultCellHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89            // 56.0
    static let firstOrLastCellHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.38        // 60.0
    
    // MARK: RightImageView
    static let rightImageConfigurationSettingsTypeImage: String = "icon_my_page_gear"
    static let rightImageViewInquriyTypeImage: String = "icon_my_page_speech_bubble"
    static let rightImageViewQuestionSuggestionsTypeImage: String = "icon_my_page_note"
    static let rightImageViewLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 2.13 // 8.0
    
    // MARK: TitleLabel
    static let titleLabelConfigurationSettingsTypeText: String = "환경설정"
    static let titleLabelInquriyTypeText: String = "문의하기"
    static let titleLabelQuestionSuggestionsTypeText: String = "새로운 질문 제안하기"
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26         // 16.0
    static let titleLabelLaedingOffset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 1.06    // 4.0
}
