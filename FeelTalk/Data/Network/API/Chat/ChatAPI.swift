//
//  ChatAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/28.
//

import RxSwift
import Alamofire

public enum ChatAPI {
    case changeChatRoomStatus(isInChat: Bool)
    case getLastestChatPageNo
    case loadChatList(pageNo: Int)
    case sendEmoji(emoji: String)
    case sendTextChat(message: String)
    case shareQuestion(index: Int)
    case shareChallenge(index: Int)
}

extension ChatAPI: Router, URLRequestConvertible {
    public var baseURL: String { ClonectAPI.BASE_URL }
    
    public var path: String {
        switch self {
        case .changeChatRoomStatus:
            return "/api/v1/member/chatting-room-status"
        case .getLastestChatPageNo:
            return "/api/v1/chatting-message/lastest/page-no"
        case .loadChatList:
            return "/api/v1/chatting-message"
        case .sendEmoji:
            return "/api/v1/chatting-message/emoji"
        case .sendTextChat:
            return "/api/v1/chatting-message/text"
        case .shareChallenge:
            return "/api/v1/chatting-message/challenge"
        case .shareQuestion:
            return "/api/v1/chatting-message/question"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .changeChatRoomStatus:
            return .put
        case .getLastestChatPageNo, .loadChatList:
            return .get
        case .sendTextChat, .shareQuestion, .shareChallenge, .sendEmoji:
            return .post
        }
    }
    
    // TODO: accessToken 어떻게 넘겨줄기 고민
    public var header: [String : String] {
        switch self {
        case .changeChatRoomStatus, .getLastestChatPageNo, .loadChatList, .sendEmoji, .sendTextChat, .shareChallenge, .shareQuestion:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json"
//                "accessToken": accessToken
            ]
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .changeChatRoomStatus(isInChat: let isInChat):
            return ["isInChat": isInChat]
        case .getLastestChatPageNo:
            return nil
        case .loadChatList(pageNo: let pageNo):
            return ["pageNo": pageNo]
        case .sendEmoji(emoji: let emoji):
            return ["emoji": emoji]
        case .sendTextChat(message: let message):
            return ["message": message]
        case .shareChallenge(index: let index):
            return ["index": index]
        case .shareQuestion(index: let index):
            return ["index": index]
        }
    }
    
    public var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .changeChatRoomStatus, .loadChatList, .sendEmoji, .sendTextChat, .shareChallenge, .shareQuestion:
            return JSONEncoding.default
        case .getLastestChatPageNo:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
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
