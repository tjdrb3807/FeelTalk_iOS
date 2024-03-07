//
//  ConfigurationAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation
import Alamofire

enum ConfigurationAPI {
    case getConfigurationInfo
    case comment(data: CommentRequestDTO)
    case getServiceDataTotalCount
    case setLockNumber(dto: LockNumberSettingsRequestDTO)
    case getLockNumber
    case setUnlock
    case resetLockNumber(dto: LockNumberResettingsRequestDTO)
    case getLockNumberHintType
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
        case .setLockNumber:
            return "/api/v1/member/config/lock"
        case .getLockNumber:
            return "/api/v1/member/config/password"
        case .setUnlock:
            return "/api/v1/member/config/unlock"
        case .resetLockNumber:
            return "/api/v1/member/config/password"
        case .getLockNumberHintType:
            return "/api/v1/member/config/question-type"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getConfigurationInfo, .comment, .getServiceDataTotalCount, .getLockNumber, .getLockNumberHintType:
            return .get
        case .setLockNumber, .resetLockNumber:
            return .post
        case .setUnlock:
            return .put
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getConfigurationInfo,
                .comment,
                .getServiceDataTotalCount,
                .setLockNumber,
                .getLockNumber,
                .setUnlock,
                .resetLockNumber,
                .getLockNumberHintType:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getConfigurationInfo, .getServiceDataTotalCount, .getLockNumber, .setUnlock, .getLockNumberHintType:
            return nil
        case .comment(data: let data):
            return ["title": data.title,
                    "body": data.body as Any,
                    "email": data.email]
        case .setLockNumber(dto: let dto):
            return ["password": dto.lockNumber,
                    "questionType": dto.hintType,
                    "answer": dto.correctAnswer]
        case .resetLockNumber(dto: let dto):
            return ["password": dto.lockNumber]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .getConfigurationInfo, .comment, .getServiceDataTotalCount, .setLockNumber, .getLockNumber, .setUnlock, .resetLockNumber, .getLockNumberHintType:
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
