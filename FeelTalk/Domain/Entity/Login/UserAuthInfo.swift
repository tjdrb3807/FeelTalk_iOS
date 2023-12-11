//
//  UserAuthInfo.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/11.
//

import Foundation

/// 성인인증시 필요한 회원 정보
///
/// UserAuthInfo(Domain) -> AuthNumberRequestDTO(Data)
struct UserAuthInfo {
    let name: String
    let birthday: String
    let genderNumber: String
    let newsAgency: NewsAgencyType
    let phoneNumber: String
}

extension UserAuthInfo {
    func convertAuthNumberRequestDTO() -> AuthNumberRequestDTO {
        .init(providerId: newsAgency.rawValue,
              userName: name,
              userPhone: phoneNumber,
              userBirthday: convertBirthday(birthday, with: genderNumber),
              userGender: convertGenderType(with: genderNumber),
              userNation: convertUserNationType(with: genderNumber))
    }
    
    func convertReAuthNumberRequestDTO() -> ReAuthNumberRequestDTO {
        .init(providerId: newsAgency.rawValue,
              userName: name,
              userPhone: phoneNumber,
              userBirthday: convertBirthday(birthday, with: genderNumber),
              userGender: convertGenderType(with: genderNumber),
              userNation: convertUserNationType(with: genderNumber))
    }
}

extension UserAuthInfo {
    private func convertBirthday(_ birthday: String, with genderNumber: String) -> String {
        var birthday = birthday
        let index01 = birthday.index(birthday.startIndex, offsetBy: 0)
        let index02 = birthday.index(birthday.startIndex, offsetBy: 1)
        
        if genderNumber == "1" || genderNumber == "2" || genderNumber == "5" || genderNumber == "6" {
            birthday.insert("1", at: index01)
            birthday.insert("9", at: index02)
        } else if  genderNumber == "3" ||  genderNumber == "4" || genderNumber == "7" || genderNumber == "8" {
            birthday.insert("2", at: index01)
            birthday.insert("0", at: index02)
        }
        
        return birthday
    }
    
    private func convertGenderType(with genderNumber: String) -> String {
        var genderType: String = ""
        
        if genderNumber == "1" || genderNumber == "3" || genderNumber == "5" || genderNumber == "7" {
            genderType = "1"
        } else if genderNumber == "2" || genderNumber == "4" || genderNumber == "6" || genderNumber == "8" {
            genderType = "2"
        }
        
        return genderType
    }
    
    private func convertUserNationType(with genderNumber: String) -> String {
        var nationType: String = ""
        
        if genderNumber == "1" || genderNumber == "2" || genderNumber == "3" || genderNumber == "4" {
            nationType = "0"
        } else if genderNumber == "5" || genderNumber == "6" || genderNumber == "7" || genderNumber == "8" {
            nationType = "1"
        }
        
        return nationType
    }
}
