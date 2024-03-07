//
//  LockNumberPadViewType.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum LockNumberPadViewType: String {
    /// 로그인시 사용
    case access = "암호입력"
    /// 초기 비빌번호 설정
    case newSettings = "암호설정"
    /// 새로운 비빌번호 설정
    case changePassword = "암호변경"
}
