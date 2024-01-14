//
//  AdultAuthNumberDescription.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/03.
//

import Foundation

enum AdultAuthNumberDescription: String {
    case base = "입력한 인증정보가 올바르지 않은 경우, 인증번호가 도착하지 않을 수 있어요."
    case expirad = "인증번호 입력시간을 초과했어요. 다시 요청해주세요."
    case mismatch = "인증번호를 다시 확인해주세요."
}
