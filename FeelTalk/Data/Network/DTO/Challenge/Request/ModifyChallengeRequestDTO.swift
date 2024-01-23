//
//  ModifyChallengeRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/23.
//

import Foundation

struct ModifyChallengeRequestDTO: Encodable {
    let index: Int
    let title: String
    let deadline: String
    let content: String
}
