//
//  SuggestionsDescriptionViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/26.
//

import Foundation

enum SuggestionsDescriptionViewNameSpace {
    // MARK: SuggestionsDescriptionView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49                      // 4.0
    
    // MARK: TitleLabel
    static let titleLabelText: String = "새로운 질문을 제안하시겠어요?"
    static let titleLableTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 6.4          // 24.0
    static let titleLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 4.43         // 36.0
    
    // MARK: DescriptionLabel
    static let descriptionLabelText: String = """
                                              연인에게 묻고 싶은 질문・서비스에 없는 질문 등
                                              다양한 질문 아이디어를 보내주세요 !
                                              """
    static let descriptionLabelNumberOfLines: Int = 0
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26   // 16.0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95
    
    
}
