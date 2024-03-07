//
//  ChallengeAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation
import Alamofire

enum ChallengeAPI {
    case addChallenge(requestDTO: AddChallengeRequestDTO)
    
    case completeChallenge(requestDTO: CompleteChallengeRequestDTO)
    
    case getChallenge(index: Int)
    
    case getChallengeCount
    
    case getCompletedChallengeLatestPageNo
    
    case getCompletedChallengeList(requestDTO: ChallengeListRequestDTO)
    
    case getOngoingChallengeLatestPageNo
    
    case getOngoingChallengeList(requestDTO: ChallengeListRequestDTO)
    
    case modifyChallenge(requestDTO: ModifyChallengeRequestDTO)
    
    case removeChallenge(requestDTO: RemoveChallengeRequestDTO)
}

extension ChallengeAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .addChallenge:
            return "/api/v1/challenge"
        case .completeChallenge:
            return "/api/v1/challenge/complete"
        case .getChallenge(index: let index):
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
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .addChallenge(requestDTO: let dto):
            return ["title": dto.title,
                    "deadline": dto.deadline,
                    "content": dto.content]
        case .completeChallenge(requestDTO: let dto):
            return ["index": dto.index]
        case .getCompletedChallengeList(requestDTO: let dto),
                .getOngoingChallengeList(requestDTO: let dto):
            return ["pageNo": dto.pageNo]
        case .getChallenge,
                .getChallengeCount,
                .getCompletedChallengeLatestPageNo,
                .getOngoingChallengeLatestPageNo:
            return nil
        case .modifyChallenge(requestDTO: let dto):
            return ["index": dto.index,
                    "title": dto.title,
                    "deadline": dto.deadline,
                    "content": dto.content]
        case .removeChallenge(requestDTO: let dto):
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
