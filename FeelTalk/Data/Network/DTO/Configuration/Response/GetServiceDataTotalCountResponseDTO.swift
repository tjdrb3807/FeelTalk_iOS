//
//  GetServiceDataTotalCountResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import Foundation

struct GetServiceDataTotalCountResponseDTO: Decodable {
    let challengeTotalCount: Int
    let questionTotalCount: Int
}

extension GetServiceDataTotalCountResponseDTO {
    func toDomain() -> ServiceDataCount {
        .init(challengeCount: challengeTotalCount,
              questionCount: questionTotalCount)
    }
}
