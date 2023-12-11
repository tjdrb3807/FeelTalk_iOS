//
//  SignUpAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/06.
//

import Foundation
import Alamofire

enum SignUpAPI {
    case signUp(request: SignUpRequestDTO)
    case getAuthNumber(_ dto: AuthNumberRequestDTO)
    case getReAuthNumber(_ dto: ReAuthNumberRequestDTO)
    case verification(_ dto: VerificationRequestDTO)
}

extension SignUpAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .signUp:
            return "/api/v1/sign-up"
        case .getAuthNumber:
            return "/api/v1/adult/authentication"
        case .getReAuthNumber:
            return "/api/v1/adult/re-authentication"
        case .verification:
            return "/api/v1/adult/authentication/verification"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp:
            return .post
        case .getAuthNumber:
            return .post
        case .getReAuthNumber:
            return .post
        case .verification:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .signUp, .getAuthNumber, .getReAuthNumber, .verification:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .signUp(request: let signUpReqeust):
            return ["snsType": signUpReqeust.snsType,
//                    "nickname": signUpReqeust.nickname,
//                    "refreshToken": signUpReqeust.refreshToken,
//                    "authCode": signUpReqeust.authCode,
//                    "idToken": signUpReqeust.idToken,
//                    "state": signUpReqeust.state,
//                    "authorizationCode": signUpReqeust.authorizationCode,
                    "fcmToken": signUpReqeust.fcmToken,
                    "marketingConsent": signUpReqeust.marketingConsent]
            
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
            return ["authNumber": requestDTO.authNumber]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .signUp, .getAuthNumber, .getReAuthNumber, .verification:
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
