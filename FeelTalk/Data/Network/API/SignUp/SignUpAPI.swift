//
//  SignUpAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/06.
//

import Foundation
import Alamofire

enum SignUpAPI {
    case getAuthNumber(_ dto: AuthNumberRequestDTO)
    case getReAuthNumber(_ dto: ReAuthNumberRequestDTO)
    case verification(_ dto: VerificationRequestDTO)
    case signUp(_ dto: SignUpRequestDTO)
}

extension SignUpAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .getAuthNumber:
            return "/api/v1/adult/authentication"
        case .getReAuthNumber:
            return "/api/v1/adult/re-authentication"
        case .verification:
            return "/api/v1/adult/authentication/verification"
        case .signUp:
            return "/api/v1/signup"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAuthNumber, .getReAuthNumber, .verification, .signUp:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getAuthNumber, .getReAuthNumber, .verification:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        case .signUp(let requestDTO):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization" : requestDTO.accessToken]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getAuthNumber(let requestDTO):
            return ["providerId": requestDTO.providerId,
                    "reqAuthType": requestDTO.reqAuthType,
                    "userName": requestDTO.userName,
                    "userPhone": requestDTO.userPhone,
                    "userBirthday": requestDTO.userBirthday,
                    "userGender": requestDTO.userGender,
                    "userNation": requestDTO.userNation]
            
        case .getReAuthNumber(let requestDTO):
            return ["serviceType": requestDTO.serviceType,
                    "providerId": requestDTO.providerId,
                    "reqAuthType": requestDTO.reqAuthType,
                    "userName": requestDTO.userName,
                    "userPhone": requestDTO.userPhone,
                    "userBirthday": requestDTO.userBirthday,
                    "userGender": requestDTO.userGender,
                    "userNation": requestDTO.userNation]
            
        case .verification(let requestDTO):
            return ["authNumber": requestDTO.authNumber,
                    "sessionUuid": requestDTO.sessionUuid]
        case .signUp(let requestDTO):
            return ["state": requestDTO.state as Any,
                    "nickname": requestDTO.nickname,
                    "marketingConsent": requestDTO.marketingConsent,
                    "fcmToken": requestDTO.fcmToken]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .getAuthNumber, .getReAuthNumber, .verification, .signUp:
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL + path)
        var request = URLRequest(url: url!)
        
        request.method = method
        request.headers = HTTPHeaders(header)
        
        if let encoding = encoding {
            return try encoding.encode(request, with: parameters)
        }
        
        return request
    }
    
    
}
