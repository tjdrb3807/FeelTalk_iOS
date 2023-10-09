//
//  CustomBottomSheetViewNameSpcae.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/02.
//

import Foundation

enum CustomBottomSheetViewNameSpcae {
    // MARK: CustomBottomSheetView
    static let showAnimateDuration: CGFloat = 0.2
    static let showAnimateDelay: CGFloat = 0.0
    static let hideAnimateDuration: CGFloat = 0.2
    static let hideAnimateDelay: CGFloat = 0.0
    static let removeFromSuperviewDelay: CGFloat = 0.2
    
    // MARK: BottomSheetView
    static let bottomSheetViewCornerRadius: CGFloat = 20.0
    static let bottomSheetViewInquiryTypeTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 52.58      // 427.0
    static let bottomSheetViewSuggestionTypeTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 49.75   // 404.0
    static let bottomSheetViewShadowPathHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46          // 20.0
    static let bottomSheetViewShadowColorRed: CGFloat = 0.0
    static let bottomSheetViewShadowColorGreen: CGFloat = 0.0
    static let bottomSheetViewShadowColorBlue: CGFloat = 0.0
    static let bottomSheetViewShadowColorAlpha: CGFloat = 0.04
    static let bottomSheetViewShadowOffsetWidth: CGFloat = 0.0
    static let bottomSheetViewShadowOffsetHeight: CGFloat = -(CommonConstraintNameSpace.verticalRatioCalculator * 0.62)     // -5.0
    static let bottomSheetViewShadowRadius: CGFloat = 20.0
    static let bottomSheetViewShadowOpacity: Float = 1.0
    
    
    
    
    // MARK: BottomSheetStackView
    static let bottomSheetStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.46              // 20.0
    static let bottomSheetStackViewTopInset: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69             // 30.0
    
    // MARK: ContentStackView
    static let contentStackViewSpacing: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 0.49                  // 4.0
    
    // MARK: TitleLabel
    static let titleLabelInquiryTypeText: String = """
                                                   문의사항을
                                                   성공적으로 전송했어요!
                                                   """
    static let titleLabelSuggestionTypeText: String = """
                                                      필로우톡에
                                                      질문을 제안했어요!
                                                      """
    static let titleLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 5.33                     // 20.0
    static let titleLabelNumberOfLines: Int = 0
    static let titleLableHeight: CGFloat = titleLableLineHeight * 2
    static let titleLableLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 3.69                     // 30.0
    
    // MARK: ImageView
    static let imageViewInquiryTypeImage: String = "image_inquiry_completion"
    static let imageViewSuggestionTypeImage: String = "image_suggestions_completion"
    static let imageViewWidth: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 40                           // 150.0
    static let imageViewHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 18.47                         // 15.0
    
    // MARK: DescriptionLabel
    static let descriptionLabelInquiryTypeText: String = """
                                                         답변은 이메일→받은메일함을 통해 확인해주세요.
                                                         """
    static let descriptionLabelSuggestionTypeText: String = """
                                                            서비스 향상에 함께해 주셔서 감사해요.
                                                            보내주신 내용은 적극적으로 검토할게요 🙌
                                                            """
    static let descriptionLabelTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26               // 16.0
    static let descriptionLabelNumberOfLines: Int = 0
    static let descriptionLabelLineHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 2.95               // 24.0
    static let descriptionLabelInquiryTypeHeight: CGFloat = descriptionLabelLineHeight
    static let dascriotionLabelSuggestionTypeHeight: CGFloat = descriptionLabelLineHeight * 2
    
    // MARK: ConfirmButton
    static let confirmButtonTitleText: String = "알겠어요"
    static let confirmButtonTitleTextSize: CGFloat = CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.8              // 18.0
    static let confirmButtonCornerRadius: CGFloat = confirmButtonHeight / 2
    static let confirmButtonHeight: CGFloat = CommonConstraintNameSpace.verticalRatioCalculator * 7.26                      // 59.0
}
