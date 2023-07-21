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
}

extension SignUpAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .signUp:
            return "/api/v1/sign-up"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .signUp:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .signUp(request: let signUpReqeust):
            return ["snsType": signUpReqeust.snsType,
                    "nickname": signUpReqeust.nickname,
                    "refreshToken": signUpReqeust.refreshToken,
                    "authCode": signUpReqeust.authCode,
                    "idToken": signUpReqeust.idToken,
                    "state": signUpReqeust.state,
                    "authorizationCode": signUpReqeust.authorizationCode,
                    "fcmToken": signUpReqeust.fcmToken,
                    "marketingConsent": signUpReqeust.marketingConsent]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .signUp:
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
