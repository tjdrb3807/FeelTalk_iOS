//
//  SignUpViewNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/18.
//

import UIKit

enum SignUpViewNameSpace {
    // MARK: SignUpViewController SubComponents
    static let nextButtonTitle: String = "다음"
    static let nextButtonTitleFont: String = "pretendard-medium"
    static let nextButtonTitleSize: CGFloat = 18.0
    static let nextButtonBackgroundColor: String = "main_400"
    static let nextButtonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.26
    static let nextButtonUpdateHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.26
    static let nextButtonUpdateHorizontalInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
    
    static let signUpSpacingViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 5.66
    static let signUpSpacingViewUpdateHeight: CGFloat = 0.0
    
    static let fullHorizontalStackViewTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 2.21
    
    
    // MARK: InformationPhraseView
    static let informationPhraseHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 11.33
    
    // MARK: InformationPhraseView SubComponents
    static let informationLabelText: String = """
                                              서비스 이용을 위해
                                              성인인증을 진행해주세요
                                              """
    static let infomationLabelUpdateText: String = """
                                                   이용약관에 동의해주세요
                                                   
                                                   """
    static let informationLableTextFont: String = "pretendard-medium"
    static let informationLabelTextSize: CGFloat = 24.0
    static let informationLabelNumberOfLines: Int = 0
    static let informationLabelLineSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 1.23
    static let informationLabelTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.23
    static let informationLabelLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
    
    // MARK: AdultCertificationView
    static let adultCertificationViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 2.46
    static let adutlCertificationViewHorizontalInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
    
    // MARK: AdultCertificationView SubComponents
    static let idCardImage: String = "image_id_card"
    static let idCardHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 28.81
    static let idCardUpdateHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 21.42
    
    static let explanationHorizontalStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.49
    
    static let explanationLabelText: String = """
                                              만 19세 이상임을 인증하면
                                              연인과 함께 필로우톡을 이용할 수 있어요
                                              """
    static let explanationLabelUpdateText: String = "성인인증 완료"
    static let explanationLabelLineSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.61
    static let explanationLabelTextColor: String = "gray_600"
    static let explanationLabelTextFont: String = "pretendard-regular"
    static let explanationLabelTextSize: CGFloat = 16.0
    static let explanationLabelNumberOfLines: Int = 0
    
    static let checkImageViewImage: String = "icon_check_green"
    
    static let authButtonTitle: String = "성인인증 하기"
    static let authButtonTitleFont: String = "pretendard-medium"
    static let authButtonTitleSize: CGFloat = 18.0
    static let authButtonBackgroundColor: String = "main_500"
    static let authButtonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.26
    static let authButtonLeadingInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
    
    static let spacingViewHeight: CGFloat = 0.0
    
    // MARK: InformationConsentView
    static let informationConsentViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 2.46
    
    // MARK: InformationConsentView SubComponents
    static let totalConsentViewBackgroundColor: String = "gray_100"
    static let totalConsentViewCornerRadius: CGFloat = 12.0
    static let totalConsetnViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.88
    
    static let totalConsentViewFullHorizontalStackViewSpacing: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2
    static let totalConsentViewFullhorizontalStackViewVerticalInset: CGFloat = (UIScreen.main.bounds.height / 100) * 2.46
    static let totalConsetnViewFullhorizontalStackViewHorizontalInset: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2
    
    static let totalConsentButtonImage: String = "icon_full_selection"
    static let totalConsentButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 6.4
    
    static let totalConsentLabelText: String = "약관 및 개인, 민감정보 수집, 이용 동의"
    static let totalConsentLabelTextFont: String = "pretendard-bold"
    static let totalConsentLabelTextSize: CGFloat = 16.0
    
    static let presentDetailConsentViewButtonImage: String = "icon_right_arrow"
    static let presentDetailConsetnViewButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 6.4
    
    static let consentHorizontalStackViewSpacing: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2
    
    static let consentVerticalStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.73
    
    // MARK: EachConsentView SubComponents
    static let checkButtonSelectedImage: String = "icon_check_selected"
    static let checkButtonUnselectedImage: String = "icon_check_unselected"
    static let checkButtonWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
    
    static let restConsentOptionLabelText: String = "[필수]"
    static let restConsentOptionLabelTextColor: String = "main_500"
    static let marketingConsentOptionLabelText: String = "[선택]"
    static let marketingConsetnOptionLabelTextColor: String = "gray_600"
    static let optionLabelTextFont: String = "pretendard-regular"
    static let optionLabelTextSize: CGFloat = 14.0
    
    static let adultConsentLabelText: String = "만 19세 이상입니다."
    static let serviceConsentLabelText: String = "서비스 이용 약관 동의"
    static let personalInfoConsentLabelText: String = "개인정보 수집 및 서비스 활용 동의"
    static let sensitiveInfoConsentLabelText: String = "민감정보 수집 및 서비스 활용 동의"
    static let marketingInfoConsentLabelText: String = "마케팅 정보 수신 동의(푸시 알림)"
    static let contentLabelTextColor: String = "gray_600"
    static let contentLabelTextFont: String = "pretendard-regular"
    static let contentLabelTextSize: CGFloat = 14.0
    
    static let eachConsentViewFirstSpacingWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 2.13
    static let eachConsetnViewSecontSpacinWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 0.53
}
