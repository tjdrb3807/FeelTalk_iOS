//
//  VerificationRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/11.
//

import Foundation

struct VerificationRequestDTO: Encodable {
    let authNumber: String
    let sessionUuid: String
}
