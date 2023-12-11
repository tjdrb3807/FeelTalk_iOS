//
//  UserAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/14.
//

import Foundation
import Alamofire

enum UserAPI {
    case getMyInfo(accessToken: String)
    case getPartnerInfo(accessToken: String)
    case getUserState(accessToken: String)
}

extension UserAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .getMyInfo:
            return "/api/v1/member"
        case .getPartnerInfo:
            return "/api/v1/member/partner"
        case .getUserState:
            return "/api/v1/member/status"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getMyInfo, .getPartnerInfo, .getUserState:
            return .get
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getMyInfo(accessToken: let accessToken),
                .getPartnerInfo(accessToken: let accessToken):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(accessToken)"]
        case .getUserState(accessToken: let accessToken):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "\(accessToken)"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getMyInfo, .getPartnerInfo, .getUserState:
            return nil
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .getMyInfo, .getPartnerInfo, .getUserState:
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
