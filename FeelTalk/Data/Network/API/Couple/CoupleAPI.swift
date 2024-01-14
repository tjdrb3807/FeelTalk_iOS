//
//  CoupleAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import Foundation
import Alamofire

enum CoupleAPI {
    case registerInviteCode(accessToken: String, inviteCode: String)
}
    
extension CoupleAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
        
    var path: String {
        switch self {
        case .registerInviteCode:
            return "/api/v1/couple"
        }
    }
        
    var method: Alamofire.HTTPMethod {
        switch self {
        case .registerInviteCode:
            return .post
        }
    }
        
    var header: [String : String] {
        switch self {
        case .registerInviteCode(accessToken: let accessToken, inviteCode: _):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": accessToken]
        }
    }
        
    var parameters: [String : Any]? {
        switch self {
        case .registerInviteCode(accessToken: _, inviteCode: let inviteCode):
            return ["inviteCode": inviteCode]
        }
    }
        
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .registerInviteCode:
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

