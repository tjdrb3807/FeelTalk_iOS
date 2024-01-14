//
//  Question.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/28.
//

import Foundation

struct Question {
    let index: Int
    let pageNo: Int
    let title: String
    let header: String
    let body: String
    let highlight: [Int]
    var myAnser: String?
    var partnerAnser: String?
    var isMyAnswer: Bool
    var isPartnerAnswer: Bool
    let createAt: String
}
