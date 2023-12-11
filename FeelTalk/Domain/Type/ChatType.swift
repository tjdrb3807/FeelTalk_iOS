//
//  ChatType.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/13.
//

import Foundation

enum ChatType: String, Equatable {
    /// 챌린지 추가
    case addChallengeChatting
    /// 오늘의 질문
    case answerChatting
    /// 메세지
    case textChatting
    /// 음성녹음
    case voiceChatting
    /// 이미지
    case imageChatting
    /// 질문
    case questionChatting
    /// 챌린지 공유
    case challengeChatting
    /// 이모지(추후 업데이트 예정)
    case emojiChatting
    /// 비밀번호 재설정 요청
    case resetPartnerPasswordChatting
    /// 질문 답변 독촉하기(쿡찌르기)
    case pressForAnswerChatting
    /// 챌린지 완료
    case completeChallengeChatting
    /// 시그널
    case signalChatting
}
