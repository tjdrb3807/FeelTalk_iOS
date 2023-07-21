//
//  TokenAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/20.
//

import Foundation
import Alamofire

enum TokenAPI {
    case renewAccessToken(request: RenewAccessTokenRequestDTO)
}

extension TokenAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .renewAccessToken:
            return "/api/v1/renew-access-token"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .renewAccessToken:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .renewAccessToken:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .renewAccessToken(request: let renewAccessTokenRequest):
            return ["refreshToken": renewAccessTokenRequest.refreshToken]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .renewAccessToken:
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
