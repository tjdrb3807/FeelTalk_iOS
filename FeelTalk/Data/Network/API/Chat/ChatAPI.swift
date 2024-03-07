//
//  ChatAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/14.
//

import Foundation
import Alamofire

enum ChatAPI {
    case getLastPageNo
    case getChatList(pnageNo: Int)
}

extension ChatAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .getLastPageNo:
            return "/api/v1/chatting-message/last/page-no"
        case .getChatList:
            return "/api/v1/chatting-messages"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getLastPageNo:
            return .get
        case .getChatList:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getLastPageNo,
            .getChatList(pnageNo: _):
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getLastPageNo:
            return nil
        case .getChatList(pnageNo: let pageNo):
            return ["pageNo": pageNo]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .getLastPageNo,
                .getChatList:
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
