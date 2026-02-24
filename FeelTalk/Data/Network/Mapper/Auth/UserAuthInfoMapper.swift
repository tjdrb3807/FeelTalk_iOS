//
//  UserAuthInfoMapper.swift
//  FeelTalk
//
//  Maps Domain entities to Data DTOs.
//
//  Created by 전성규 on 2/24/26.
//

import Foundation

enum UserAuthInfoMapper {
    static func toAuthNumberRequestDTO(from entity: UserAuthInfo) -> AuthNumberRequestDTO? {
        guard let name = entity.name,
              let birthday = entity.birthday,
              let genderNumber = entity.genderNumber,
              let newsAgency = entity.newsAgency,
              let phoneNumber = entity.phoneNumber else { return nil }
        
        return AuthNumberRequestDTO(
            providerId: newsAgency.rawValue,
            userName: name,
            userPhone: phoneNumber,
            userBirthday: convertBirthday(birthday, with: genderNumber),
            userGender: convertGenderType(with: genderNumber),
            userNation: convertUserNationType(with: genderNumber))
    }
    
    private static func convertBirthday(_ birthday: String, with genderNumber: String) -> String {
        var birthday = birthday
        let index01 = birthday.index(birthday.startIndex, offsetBy: 0)
        let index02 = birthday.index(birthday.startIndex, offsetBy: 1)
        
        if genderNumber == "1" || genderNumber == "2" || genderNumber == "5" || genderNumber == "6" {
            birthday.insert("1", at: index01)
            birthday.insert("9", at: index02)
        } else if genderNumber == "3" || genderNumber == "4" || genderNumber == "7" || genderNumber == "8" {
            birthday.insert("2", at: index01)
            birthday.insert("0", at: index02)
        }
        
        return birthday
    }
    
    private static func convertGenderType(with genderNumber: String) -> String {
        if genderNumber == "1" || genderNumber == "3" || genderNumber == "5" || genderNumber == "7" {
            return "1"
        } else if genderNumber == "2" || genderNumber == "4" || genderNumber == "6" || genderNumber == "8" {
            return "2"
        }
        return ""
    }
    
    private static func convertUserNationType(with genderNumber: String) -> String {
        if genderNumber == "1" || genderNumber == "2" || genderNumber == "3" || genderNumber == "4" {
            return "0"
        } else if genderNumber == "5" || genderNumber == "6" || genderNumber == "7" || genderNumber == "8" {
            return "1"
        }
        return ""
    }
}
