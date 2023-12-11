//
//  AuthNumberRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/11.
//

import Foundation

struct AuthNumberRequestDTO: Encodable {
    var providerId: String
    var reqAuthType: String = "SMS"
    var userName: String
    var userPhone: String
    var userBirthday: String
    var userGender: String
    var userNation: String
}

struct ReAuthNumberRequestDTO: Encodable {
    let serviceType: String = "telcoAuth"
    var providerId: String
    var reqAuthType: String = "SMS"
    var userName: String
    var userPhone: String
    var userBirthday: String
    var userGender: String
    var userNation: String
}
