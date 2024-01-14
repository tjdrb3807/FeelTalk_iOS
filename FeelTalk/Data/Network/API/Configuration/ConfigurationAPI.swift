//
//  ConfigurationAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation
import Alamofire

enum ConfigurationAPI {
    case getConfigurationInfo(accessToken: String)
    case comment(accessToken: String, data: CommentRequestDTO)
    case getServiceDataTotalCount(accessToken: String)
    
}

extension ConfigurationAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .getConfigurationInfo:
            return "/api/v1/member/config"
        case .comment:
            return "/api/v1/comment"
        case .getServiceDataTotalCount:
            return "/api/v1/member/service-data"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getConfigurationInfo, .comment, .getServiceDataTotalCount:
            return .get
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getConfigurationInfo(accessToken: let accessToken),
                .comment(accessToken: let accessToken, data: _),
                .getServiceDataTotalCount(accessToken: let accessToken):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": accessToken]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getConfigurationInfo, .getServiceDataTotalCount:
            return nil
        case .comment(accessToken: _, data: let data):
            return ["title": data.title,
                    "body": data.body as Any,
                    "email": data.email]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .getConfigurationInfo, .comment, .getServiceDataTotalCount:
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
