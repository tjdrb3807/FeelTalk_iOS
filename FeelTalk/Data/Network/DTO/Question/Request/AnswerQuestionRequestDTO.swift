//
//  AnswerQuestionRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/11.
//

import Foundation

struct AnswerQuestionRequestDTO: Encodable {
    let index: Int
    let myAnswer: String
}
