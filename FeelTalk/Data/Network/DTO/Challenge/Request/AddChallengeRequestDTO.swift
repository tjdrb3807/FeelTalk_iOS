//
//  AddChallengeRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/17.
//

import Foundation

struct AddChallengeRequestDTO: Decodable {
    let title: String
    let deadline: String
    let content: String
}
