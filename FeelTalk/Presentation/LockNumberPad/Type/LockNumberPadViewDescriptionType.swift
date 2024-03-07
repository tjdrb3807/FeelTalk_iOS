//
//  LockNumberPadViewDescriptionType.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation

enum LockNumberPadViewDescriptionType: String {
    case newPasswordInput = "새로운 암호를 입력해주세요"
    case onemoreNewPasswordInput = "새로운 암호를 다시 한 번 입력해주세요"
    case initPasswordInput = "사용하고자 하는 암호를 입력해주세요."
    case onemoreInitPasswordInput = "확인을 위해 한 번 더 입력해주세요"
    case differentPassword = """
                            입력한 암호가 일치하지 않습니다.
                            처음부터 다시 입력해주세요
                            """
    case missMatchPassword = "입력한 암호가 일치하지 않습니다."
}
