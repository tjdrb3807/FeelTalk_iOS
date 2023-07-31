//
//  GetLatestQuestionPageNoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/26.
//

import Foundation

struct GetLatestQuestionPageNoResponseDTO: Decodable {
    let pageNo: Int
    
    enum CodingKeys: String, CodingKey {
        case pageNo
    }
}
