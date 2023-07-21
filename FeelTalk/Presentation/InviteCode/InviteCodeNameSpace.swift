//
//  InviteCodeNameSpace.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import UIKit

enum InviteCodeNameSpace {
    // MARK: InviteCodeViewController
    static let baseHorizontalInset: CGFloat = (UIScreen.main.bounds.width / 100) * 5.33
    
    // MARK: ViewTitleLabel
    static let viewTitleLabelText: String = "연인코드 연결"
    static let viewTitleLabelTextFont: String = "pretendard-medium"
    static let viewTitleLabelTextSize: CGFloat = 18.0
    static let viewTitleLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.38
    
    // MARK: InviteCodeInfoPhraseView
    static let inviteCodeInfoPhraseViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.49
    static let inviteCodeInfoPhraseViewTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 1.97
    static let inviteCodeINfoPhraseViewHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 11.45
    
    // MARK: InviteCodeInfoPhraseView SubComponents
    static let titleLabelText: String = "연인에게 보낼 초대장을 준비했어요"
    static let titleLabelTextFont: String = "pretendard-medium"
    static let titleLabelTextSize: CGFloat = 24.0
    static let titleLabelHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 4.43
    
    static let descriptionLabelText: String = """
                                              연결코드를 공유해 기기를 연결해주세요
                                              코드를 공유받았다면, 하단 버튼을 눌러 입력해주세요
                                              """
    static let descriptionLabelTextColor: String = "gray_600"
    static let descriptionLabelTextFont: String = "pretendard-regular"
    static let descriptionLabelTextSize: CGFloat = 16.0
    static let descriptionLabelLineSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 0.98
    static let descriptionLabelNumberOfLines: Int = 2
    
    // MARK: NoteBackgroundView
    static let noteBackgroundViewTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 3.94
    static let noteBackgroundViewBottomOffest: CGFloat = -((UIScreen.main.bounds.height / 100) * 4.61)
    
    // MARK: InviateCodeNoteView
    static let inviteCodeNoteViewTopOffset: CGFloat = (UIScreen.main.bounds.height / 100) * 11.33
    static let inviteCodeNoteViewHorizontalInset: CGFloat = (UIScreen.main.bounds.width / 100) * 11.2
    static let inviteCodeNoteViewBottomOffset: CGFloat = -((UIScreen.main.bounds.height / 100) * 8.86)
    
    // MARK: InviateCodeNoteView SubComponents
    static let inviteCodeNoteViewTotalVerticalStackViewSpacing: CGFloat = (UIScreen.main.bounds.height / 100) * 1.23
    
    static let inviteCodeNoteViewTitleLabelText: String = "나의 연인코드"
    static let inviteCodeNoteViewTitleLabelTextFont: String = "pretendard-regular"
    static let inviteCodeNoteViewTitleLabelTextSize: CGFloat = 14.0
    
    // MARK: inputCodeButton
    static let inputCodeButtonTitleText: String = "공유받은 코드 입력"
    static let inputCodeButtonTitleTextFont: String = "pretendard-medium"
    static let inputCodeButtonTitleTextSize: CGFloat = 18.0
    static let inputCodeButtonHeight: CGFloat = (UIScreen.main.bounds.height / 100) * 7.26
}
