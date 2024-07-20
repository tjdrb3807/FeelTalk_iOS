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
    case sendTextChat(text: String)
    case sendImageChat(image: UIImage)
    case sendVoiceChat(audio: Data)
}

extension ChatAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .getLastPageNo:
            return "/api/v1/chatting-message/last/page-no"
        case .getChatList:
            return "/api/v1/chatting-messages"
        case .sendTextChat:
            return "/api/v1/chatting-message/text"
        case .sendImageChat:
            return "/api/v1/chatting-message/image"
        case .sendVoiceChat:
            return "/api/v1/chatting-message/voice"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getLastPageNo:
            return .get
        case .getChatList:
            return .post
        case .sendTextChat:
            return .post
        case .sendImageChat:
            return .post
        case .sendVoiceChat:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getLastPageNo,
            .getChatList(pnageNo: _),
            .sendTextChat(text: _):
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
       case .sendImageChat(image: _),
                .sendVoiceChat(audio: _):
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getLastPageNo,
                .sendImageChat(image: _),
                .sendVoiceChat(audio: _):
            return nil
        case .getChatList(pnageNo: let pageNo):
            return ["pageNo": pageNo]
        case .sendTextChat(text: let message):
            return ["message": message]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .getLastPageNo,
                .getChatList,
                .sendTextChat:
            return JSONEncoding.default
        case .sendImageChat,
                .sendVoiceChat:
            return nil
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
