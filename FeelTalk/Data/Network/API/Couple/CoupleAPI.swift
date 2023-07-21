//
//  CoupleAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import Foundation
import Alamofire

enum CoupleAPI {
    case getInviteCode(accessToken: String)
}
    
extension CoupleAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
        
    var path: String {
        switch self {
        case .getInviteCode:
            return "/api/v1/member/invite-code"
        }
    }
        
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getInviteCode:
            return .get
        }
    }
        
    var header: [String : String] {
        switch self {
        case .getInviteCode(let accessToken):
            print(accessToken)
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": accessToken]
        }
    }
        
    var parameters: [String : Any]? {
        switch self {
        case .getInviteCode:
            return nil
        }
    }
        
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .getInviteCode:
            return JSONEncoding.default
        }
    }
        
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL + path)
        var request = URLRequest(url: url!)
        
        request.method = method
        request.headers = HTTPHeaders(header)
    
        print(request.headers)
        
        if let encoding = encoding {
            return try encoding.encode(request, with: parameters)
        }
        
        return request
    }
}

