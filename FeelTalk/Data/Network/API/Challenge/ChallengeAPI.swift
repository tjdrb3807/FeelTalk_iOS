//
//  ChallengeAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation
import Alamofire

enum ChallengeAPI {
    case addChallenge(accessToken: String, requestDTO: AddChallengeRequestDTO)
    
    case completeChallenge(accessToken: String, requestDTO: CompleteChallengeRequestDTO)
    
    case getChallenge(accessToken: String, index: Int)
    
    case getChallengeCount(accessToken: String)
    
    case getCompletedChallengeLatestPageNo(accessToken: String)
    
    case getCompletedChallengeList(accessToken: String, requestDTO: ChallengeListRequestDTO)
    
    case getOngoingChallengeLatestPageNo(accessToken: String)
    
    case getOngoingChallengeList(accessToken: String, requestDTO: ChallengeListRequestDTO)
    
    case modifyChallenge(accessToken: String, requestDTO: ModifyChallengeRequestDTO)
    
    case removeChallenge(accessToken: String, requestDTO: RemoveChallengeRequestDTO)
}

extension ChallengeAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .addChallenge:
            return "/api/v1/challenge"
        case .completeChallenge:
            return "/api/v1/challenge/complete"
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
        case .modifyChallenge:
            return "/api/v1/challenge"
        case.removeChallenge:
            return "/api/v1/challenge"
            
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .addChallenge:
            return .post
        case .completeChallenge,
                .modifyChallenge:
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
        case .addChallenge(accessToken: let accessToken, requestDTO: _),
                .completeChallenge(accessToken: let accessToken, requestDTO: _),
                .getChallenge(accessToken: let accessToken, index: _),
                .getChallengeCount(accessToken: let accessToken),
                .getCompletedChallengeLatestPageNo(accessToken: let accessToken),
                .getCompletedChallengeList(accessToken: let accessToken, requestDTO: _),
                .getOngoingChallengeLatestPageNo(accessToken: let accessToken),
                .getOngoingChallengeList(accessToken: let accessToken, requestDTO: _),
                .modifyChallenge(accessToken: let accessToken, requestDTO: _),
                .removeChallenge(accessToken: let accessToken, requestDTO: _):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": accessToken]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .addChallenge(accessToken: _, requestDTO: let dto):
            return ["title": dto.title,
                    "deadline": dto.deadline,
                    "content": dto.content]
        case .completeChallenge(accessToken: _, requestDTO: let dto):
            return ["index": dto.index]
        case .getCompletedChallengeList(accessToken: _, requestDTO: let dto),
                .getOngoingChallengeList(accessToken: _, requestDTO: let dto):
            return ["pageNo": dto.pageNo]
        case .getChallenge,
                .getChallengeCount,
                .getCompletedChallengeLatestPageNo,
                .getOngoingChallengeLatestPageNo:
            return nil
        case .modifyChallenge(accessToken: _, requestDTO: let dto):
            return ["index": dto.index,
                    "title": dto.title,
                    "deadline": dto.deadline,
                    "content": dto.content]
        case .removeChallenge(accessToken: _, requestDTO: let dto):
            return ["index": dto.index]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .addChallenge,
                .completeChallenge,
                .getChallenge,
                .getChallengeCount,
                .getCompletedChallengeLatestPageNo,
                .getCompletedChallengeList,
                .getOngoingChallengeLatestPageNo,
                .getOngoingChallengeList,
                .modifyChallenge,
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
