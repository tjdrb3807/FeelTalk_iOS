//
//  QuestionBaseResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/26.
//

import Foundation

struct QuestionBaseResponseDTO: Decodable {
    let index: Int
    let pageNo: Int
    let title: String
    let header: String
    let body: String
    let highlight: [Int]
    let myAnswer: String?
    let partnerAnswer: String?
    let isMyAnswer: Bool
    let isPartnerAnswer: Bool
    let createAt: Date
    
    enum CodingKeys: String, CodingKey {
        case index
        case pageNo
        case title
        case header
        case body
        case highlight
        case myAnswer
        case partnerAnswer
        case isMyAnswer
        case isPartnerAnswer
        case createAt
    }
}

extension QuestionBaseResponseDTO {
    func toDomain() -> Question {
        return .init(index: index,
                     pageNo: pageNo,
                     title: title,
                     header: header,
                     body: body,
                     highlight: highlight,
                     myAnser: myAnswer,
                     partnerAnser: partnerAnswer,
                     isMyAnswer: isMyAnswer,
                     isPartnerAnswer: isPartnerAnswer,
                     createAt: createAt)
    }
}
