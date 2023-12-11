//
//  LoginAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import Alamofire

enum LoginAPI {
    case autoLogin(accessToken: String)
    case reLogin(request: ReLoginRequestDTO)
    case login(_ data: LoginRequestDTO)
}

extension LoginAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .autoLogin:
            return "/api/v1/"
        case .reLogin:
            return "/api/v1/re-login"
        case .login:
            return "/api/v1/login"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .autoLogin:
            return .get
        case .reLogin:
            return .post
        case .login:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .autoLogin(accessToken: let accessToken):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "AccessToken": accessToken]
        case .reLogin:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        case .login:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .autoLogin:
            return nil
        case .reLogin(request: _):
//            return ["snsType": reLoginRequest.snsType,
//                    "refreshToken": reLoginRequest.refreshToken,
//                    "authCode": reLoginRequest.authCode,
//                    "idToken": reLoginRequest.idToken,
//                    "state": reLoginRequest.state,
//                    "authorizationCode": reLoginRequest.authorizationCode]
            return [:]
        case .login(let requestDTO):
            return ["oauthId": requestDTO.oauthId,
                    "snsType": requestDTO.snsType]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .autoLogin, .reLogin, .login:
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
