//
//  QuestionListResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/01.
//

import Foundation

struct QuestionListResponseDTO: Decodable {
    let questions: [QuestionBaseResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case questions
    }
}
