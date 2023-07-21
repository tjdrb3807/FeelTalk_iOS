//
//  AutoLoginResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/20.
//

import Foundation

struct AutoLoginResponseDTO: Decodable {
    let signUpState: String
    
    enum CodingKeys: String, CodingKey {
        case signUpState
    }
}
