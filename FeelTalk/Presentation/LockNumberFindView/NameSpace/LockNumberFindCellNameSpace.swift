//
//  LockNumberFindCellNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/16.
//

import Foundation

enum LockNumberFindCellNameSpace {
    // MARK: LockNumberFindCell
    /// 16.0
    static let cornerRadius: CGFloat = 16.0
    /// 1.0
    static let borderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.26
    /// 89.0
    static let height: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 10.96
    
    // MARK: ContentStackView
    /// 4.0
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49
    
    // MARK: Title
    /// 16.0
    static let titleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 24.0
    static let titleLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    /// "연인에게 도움 요청하기"
    static let titleLabelPartnerRequestTypeText: String = "연인에게 도움 요청하기"
    /// "필로우톡에 메일 보내기"
    static let titleLabelSendEmailTypeText: String = "필로우톡에 메일 보내기"
    
    
    // MARK: DescriptionLabel
    /// 14.0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.73
    /// 21.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.58
    /// "연인이 암호를 재설정할 수 있는 링크를 보내줘요"
    static let descriptionLabelPartnerReqeustTypeText: String = "연인이 암호를 재설정할 수 있는 링크를 보내줘요"
    /// "필로우톡에 내 정보를 인증하고 암호를 재설정해요"
    static let descriptionLabelSendEmailTypeText: String = "필로우톡에 내 정보를 인증하고 암호를 재설정해요"
}
