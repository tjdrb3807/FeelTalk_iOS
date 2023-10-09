//
//  InquiryContentInputViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import Foundation

enum InquiryContentInputViewNameSpace {
    // MARK: InquiryContentInputView
    static let spacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 1.47                                  // 12.0
    
    // MARK: TitleInputTextField
    static let titleInputTextFieldFontSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.66            // 16.0
    static let titleInputTextFieldPlaceholderText: String = "제목"
    static let titleInputTextFieldBorderWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 0.53         // 2.0
    static let titleInputTextFieldCornerRadius: CGFloat = 12.0
    static let titleInputTextFieldLeftPaddingViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 3.2 // 12.0
    static let titleInputTextFieldHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 6.89                // 56.0
    
    // MARK: ContentInputView
    static let contentInputTextViewPlaceholder: String = "페이지 에러, 건의사항, 필로우톡에게 궁금한 점 등 자유롭게 문의 내용을 작성해 주세요 !"
    static let contentInputTextViewMaxTextCount: Int = 100
    static let contentInputTextViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 19.45                  // 158.0
}
