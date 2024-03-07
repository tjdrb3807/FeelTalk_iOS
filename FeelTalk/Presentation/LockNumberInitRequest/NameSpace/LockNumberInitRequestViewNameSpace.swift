//
//  LockNumberInitRequestViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/16.
//

import Foundation

enum LockNumberInitRequestViewNameSpace {
    // MARK: TitleLabel
    /// "연인에게\n도움을 요철할까요?"
    static let titleLabelText: String = """
                                         연인에게
                                         도움을 요청할까요?
                                         """
    /// 24.0
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4
    /// 0
    static let titleLabelNumberOfLines: Int = 0
    /// 36.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43
    /// 32.0
    static let titleLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.94
    
    // MARK: SOSImage
    /// "image_request_lock_number_init"
    static let sosImage: String = "image_request_lock_number_init"
    /// 134.0
    static let sosImageTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 16.50
    /// 22.0
    static let sosImageLeadingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.86
    /// 22.0
    static let sosImageTrailingInset: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.86
    /// 331.0
    static let sosImageHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 40.76
    
    // MARK: DescriptionLabel
    /// "연인이 내 요청을 수락하면\n암호를 재설정할 수 있는 링크를 받을 수 있어요"
    static let descriptionLabelText: String = """
                                               연인이 내 요청을 수락하면
                                               암호를 재설정할 수 있는 링크를 받을 수 있어요
                                               """
    /// 16.0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26
    /// 0
    static let descriptionLabelNumberOfLines: Int = 0
    /// 24.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    /// 489.0
    static let descriptionLabelTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 60.22
    
    // MARK: RequestButton
    /// "요청하기"
    static let requestButtonTitleText: String = "요청하기"
    /// 18.0
    static let requestButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8
    /// 29.5
    static let requestButtonCornerRadius: CGFloat = requestButtonHeight / 2
    /// 561.0
    static let requestButtonTopOffset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 69.08
    /// 59.0
    static let requestButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26
}
