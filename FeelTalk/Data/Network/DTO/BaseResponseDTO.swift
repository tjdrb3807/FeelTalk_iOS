//
//  BaseResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/28.
//

import Foundation

struct BaseResponseDTO<T: Decodable>: Decodable {
    let status: String?
    let message: String?
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
}
