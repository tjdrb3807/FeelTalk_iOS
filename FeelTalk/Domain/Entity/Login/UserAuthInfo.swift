//
//  UserAuthInfo.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/11.
//

import Foundation

/// 성인인증시 필요한 회원 정보
struct UserAuthInfo: Equatable {
    var name: String?
    var birthday: String?
    var genderNumber: String?
    var newsAgency: NewsAgencyType?
    var phoneNumber: String?
}
