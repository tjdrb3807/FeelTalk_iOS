//
//  NicknameError.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/18.
//

import Foundation

enum NicknameError: String {
    case none
    case moreNumberOfChar = "닉네임은 최대 10자까지 만들 수 있어요."
    case ignoreRegularExpression = "닉네임에 특수문자/공백은 사용할 수 없어요."
}
