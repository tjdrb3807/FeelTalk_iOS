//
//  Login.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/08.
//

import Foundation

struct Login: Equatable {
    let signUpState: SignUpState
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int?
}
