//
//  QuestionBaseResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/26.
//

import Foundation

struct QuestionBaseResponseDTO: Decodable {
    let index: Int // ok
    let pageNo: Int //ok
    let title: String //ok
    let header: String //ok
    let body: String //ok
    let highlight: [Int] //ok
    let myAnswer: String? //ok
    let partnerAnswer: String? //ok
    let isMyAnswer: Bool // ok
    let isPartnerAnswer: Bool //ok
    let createAt: String //ok
    
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
