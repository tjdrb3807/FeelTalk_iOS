//
//  InviteCodeBottomSheetNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/23.
//

import UIKit

enum InviteCodeBottomSheetNameSpace {
    // MARK: BottomSheetViewController
    static let baseSidesInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
    static let animateDuration: CGFloat = 0.3
    static let animateDelay: CGFloat = 0.0
    static let keyboardDefaultHeight: CGFloat = 0.0
    
    // MARK: DimmedView
    static let dimmedViewBackgroundDefaultAlpha: CGFloat = 0.0
    static let dimmedViewBackgroundUpdateAlpha: CGFloat = 0.4
    
    // MARK: BottomSheetView
    static let bottomSheetViewCornerRadius: CGFloat = 20.0
    static let bottomSheetViewDefaultHeight: CGFloat = 0.0
    static let bottomSheetViewUpdateHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 33.74
    
    // MARK: Gradder
    static let gradderBackgroundColor: String = "gray_400"
    static let gradderCornerRadius: CGFloat = gradderHeight / 2
    static let gradderHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 0.61
    static let gradderTopInset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97
    static let gradderWidth: CGFloat = (UIScreen.main.bounds.width / 100) * 13.86
    
    // MARK: TitleLabel
    static let titleLabelText: String = "공유받은 연결코드를 입력해주세요"
    static let titleLabelTextFont: String = "pretendard-medium"
    static let titleLabelTextSize: CGFloat = 20.0
    static let titleLabelTopOffest: CGFloat = (UIScreen.main.bounds.height / 100) * 3.69
    static let titlsLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 3.69
    
    // MARK: TextField
    static let textFieldPlaceholerText: String = "연결코드 입력하기"
    static let textFieldBackgroundColor: String = "gray_200"
    static let textFieldCornerRadius: CGFloat = 8.0
    static let textFieldLeftPadding: CGFloat = (UIScreen.main.bounds.width / 100) * 3.2
    static let textFieldTopOffest: CGFloat = (UIScreen.main.bounds.height / 100) * 2.21
    static let textFieldHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 6.59
    
    // MARK: ConnectionButton
    static let connectionButtonTitleText: String = "연결하기"
    static let connectionButtonTitleTextFont: String = "pretendard-medium"
    static let connectionButtonTitelTextSize: CGFloat = 18.0
    static let connectionButtonDisableBackgroundColor: String = "main_400"
    static let connectionButtonEnableBackgroundColor: String = "main_500"
    static let connectionButtonCornerRadius: CGFloat = connectionButtonHeight / 2
    static let connectionButtonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.26
    static let connectionButtonTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 2.83
}
