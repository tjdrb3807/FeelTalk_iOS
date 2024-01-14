//
//  SignalAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/03.
//

import Foundation
import Alamofire

enum SignalAPI {
    case getMySignal(_ accessToken: String)
    case getPartnerSignal(_ accessToken: String)
    case changeMySignal(accessToken: String, dto: ChangeMySignalRequestDTO)
}

extension SignalAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .getMySignal:
            return "/api/v1/member/signal"
        case .getPartnerSignal:
            return "/api/v1/member/partner/signal"
        case .changeMySignal:
            return "/api/v1/chatting-message/signal"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getMySignal, .getPartnerSignal:
            return .get
        case .changeMySignal:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getMySignal(let accessToken),
                .getPartnerSignal(let accessToken),
                .changeMySignal(accessToken: let accessToken, dto: _):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization" : accessToken]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getMySignal, .getPartnerSignal:
            return nil
        case .changeMySignal(accessToken: _, dto: let dto):
            return ["mySignal": dto.mySignal]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .getMySignal, .getPartnerSignal, .changeMySignal:
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
