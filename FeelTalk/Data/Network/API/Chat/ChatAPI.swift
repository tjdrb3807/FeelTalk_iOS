//
//  ChatAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/18.
//

import Foundation
import Alamofire

enum ChatAPI {
    case sendTextChat(accessToken: String, _ dto: SendTextChatRequestDTO)
    case getLatestChatPageNo(accessToken: String)
}

extension ChatAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .sendTextChat:
            return "/api/v1/chatting-message/text"
        case .getLatestChatPageNo:
            return "/api/v1/chatting-message/last/page-no"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .sendTextChat:
            return .post
        case .getLatestChatPageNo:
            return .get
        }
    }
    
    var header: [String : String] {
        switch self {
        case .sendTextChat(accessToken: let accessToken, _),
                .getLatestChatPageNo(accessToken: let accessToken):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(accessToken)"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .sendTextChat(accessToken: _, let dto):
            return ["message": dto.message]
        case .getLatestChatPageNo:
            return nil
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .sendTextChat, .getLatestChatPageNo:
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
