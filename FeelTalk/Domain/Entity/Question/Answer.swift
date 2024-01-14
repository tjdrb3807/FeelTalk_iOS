//
//  Answer.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/11.
//

import Foundation

struct Answer {
    let index: Int
    let myAnswer: String
}

extension Answer {
    func toDTO() -> AnswerQuestionRequestDTO {
        .init(index: index, myAnswer: myAnswer)
    }
}
