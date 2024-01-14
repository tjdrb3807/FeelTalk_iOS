//
//  ChallengeAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation
import Alamofire

enum ChallengeAPI {
    case completeChallenge(accessToken: String, index: Int)
    
    case getChallenge(accessToken: String, index: Int)
    
    case getChallengeCount(accessToken: String)
    
    case getCompletedChallengeLatestPageNo(accessToken: String)
    
    case getCompletedChallengeList(accessToken: String, requestDTO: ChallengeListRequestDTO)
    
    case getOngoingChallengeLatestPageNo(accessToken: String)
    
    case getOngoingChallengeList(accessToken: String, requestDTO: ChallengeListRequestDTO)
    
    case removeChallenge(accessToken: String, index: Int)
}

extension ChallengeAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .completeChallenge:
            return "/api/v1/challnege/complete"
        case .getChallenge(accessToken: _, index: let index):
            return "/api/v1/challenge/\(index)"
        case .getChallengeCount:
            return "/api/v1/challenge/count"
        case .getCompletedChallengeLatestPageNo:
            return "/api/v1/challenge/done/last/page-no"
        case .getCompletedChallengeList:
            return "/api/v1/challenges/done"
        case .getOngoingChallengeLatestPageNo:
            return "/api/v1/challenge/in-progress/last/page-no"
        case .getOngoingChallengeList:
            return "/api/v1/challenges/in-progress"
        case.removeChallenge:
            return "/api/v1/challenge"
        
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .completeChallenge:
            return .put
        case .getChallenge,
                .getChallengeCount,
                .getCompletedChallengeLatestPageNo,
                .getOngoingChallengeLatestPageNo:
            return .get
        case .getCompletedChallengeList,
                .getOngoingChallengeList:
            return .post
        case .removeChallenge:
            return .delete
        }
    }
    
    var header: [String : String] {
        switch self {
        case .completeChallenge(accessToken: let accessToken, index: _),
                .getChallenge(accessToken: let accessToken, index: _),
                .getChallengeCount(accessToken: let accessToken),
                .getCompletedChallengeLatestPageNo(accessToken: let accessToken),
                .getCompletedChallengeList(accessToken: let accessToken, requestDTO: _),
                .getOngoingChallengeLatestPageNo(accessToken: let accessToken),
                .getOngoingChallengeList(accessToken: let accessToken, requestDTO: _),
                .removeChallenge(accessToken: let accessToken, index: _):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": accessToken]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .completeChallenge(accessToken: _, index: let index),
                .removeChallenge(accessToken: _, index: let index):
            return ["index": index]
        case .getCompletedChallengeList(accessToken: _, requestDTO: let dto),
                .getOngoingChallengeList(accessToken: _, requestDTO: let dto):
            return ["pageNo": dto.pageNo]
        case .getChallenge,
                .getChallengeCount,
                .getCompletedChallengeLatestPageNo,
                .getOngoingChallengeLatestPageNo:
            return nil
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .completeChallenge,
                .getChallenge,
                .getChallengeCount,
                .getCompletedChallengeLatestPageNo,
                .getCompletedChallengeList,
                .getOngoingChallengeLatestPageNo,
                .getOngoingChallengeList,
                .removeChallenge:
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
