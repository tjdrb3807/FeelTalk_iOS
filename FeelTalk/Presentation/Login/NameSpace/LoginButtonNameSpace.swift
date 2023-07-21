//
//  LoginViewButtonNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import UIKit

enum LoginButtonNameSpace {
    // MARK: Attribute
    static let appleIcon: String = "icon_apple"
    static let appleText: String = "Apple로 계속하기"
    
    static let googleIcon: String = "icon_google"
    static let googleText: String = "Google로 계속하기"
    
    static let kakaoIcon: String = "icon_kakao"
    static let kakaoText: String = "카카오로 계속하기"
    
    static let naverIcon: String = "icon_naver"
    static let naverText: String = "네이버로 계속하기"
    
    static let labelFont: String = "pretendard-medium"
    static let labelSize: CGFloat = 18.0
    
    static let borderWidth: CGFloat = 1.0
    static let borderColor: String = "gray_300"
    
    
    // MARK: Constraint
    static let fullHorizontalStakcViewSpacing: CGFloat = (UIScreen.main.bounds.width / 100) * 2.66
    
    static let iconWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 6.4
    
    static let buttonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.26
}

