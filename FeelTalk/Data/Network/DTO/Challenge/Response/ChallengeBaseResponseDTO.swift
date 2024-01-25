//
//  ChallengeBaseResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/16.
//

import Foundation

struct ChallengeBaseResponseDTO: Decodable {
    let index: Int
    let pageNo: Int
    let title: String
    let deadline: String
    let content: String
    let creator: String
    let isCompleted: Bool
    let completeDate: String?
    
    enum CodingKeys: String, CodingKey {
        case index
        case pageNo
        case title
        case deadline
        case content
        case creator
        case isCompleted
        case completeDate
    }
}

extension ChallengeBaseResponseDTO {
    func toDomain() -> Challenge {
        .init(index: index,
              pageNo: pageNo,
              title: title,
              deadline: deadline,
              content: content,
              creator: creator,
              isCompleted: isCompleted,
              completeDate: completeDate)
    }
}
