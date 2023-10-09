//
//  CommentRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/30.
//

import Foundation

struct CommentRequestDTO: Encodable {
    let title: String
    let body: String?
    let email: String
}
