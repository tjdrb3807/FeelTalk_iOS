//
//  LoginAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import Alamofire

enum LoginAPI {
    case autoLogin
    case reLogin(request: ReLoginRequestDTO)
    case login(_ data: LoginRequestDTO)
    case reissuanceAccessToken(requestDTO: AccessTokenReissuanceRequestDTO)
    case logout
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
        case .reissuanceAccessToken:
            return "/api/v1/reissue"
        case .logout:
            return "/api/v1/logout"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .autoLogin:
            return .get
        case .reLogin, .logout:
            return .post
        case .login, .reissuanceAccessToken:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .autoLogin, .reLogin, .login, .logout:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        case .reissuanceAccessToken(requestDTO: let requestDTO):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": requestDTO.accessToken,
                    "Authorization-refresh": requestDTO.refreshToken]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .autoLogin, .reissuanceAccessToken, .logout:
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
        case .autoLogin, .reLogin, .login, .reissuanceAccessToken, .logout:
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
