//
//  ChallengeAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation
import Alamofire

enum ChallengeAPI {
    case addChallenge(accessToken: String, challenge: Challenge) // 챌린지 추가하기
    case modifiyChallenge(accessToken: String, challenge: Challenge)
    case removeChallenge(accessToken: String, index: Int)
    case getChallenge(accessToken: String, index: Int)
    case completeChallenge(accessToken: String, index: Int)
    case getChallengeCount(accessToken: String)
    case getOngoingChallengeList(accessToken: String, pageNo: ChallengePage)
    case getLatestOngingChallengePageNo(accessToken: String)
    case getCompletedChallengeList(accessToken: String, pageNo: ChallengePage)
    case getLatestCompletedChallengePageNo(accessToken: String)
}

extension ChallengeAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .addChallenge, .modifiyChallenge, .removeChallenge:
            return "/api/v1/challenge"
        case .getChallenge(accessToken: _, index: let index):
            return "/api/v1/challenge/\(index)"
        case .getChallengeCount:
            return "/api/v1/challenge/count"
        case .completeChallenge:
            return "/api/v1/challnege/complete"
        case .getOngoingChallengeList:
            return "/api/v1/challenges/in-progress"
        case .getLatestOngingChallengePageNo:
            return "/api/v1/challenge/in-progress/last/page-no"
        case .getCompletedChallengeList:
            return "/api/v1/challenges/done"
        case .getLatestCompletedChallengePageNo:
            return "/api/v1/challenge/done/last/page-no"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .addChallenge, .getOngoingChallengeList, .getCompletedChallengeList:
            return .post
        case .getChallenge, .getChallengeCount, .getLatestOngingChallengePageNo, .getLatestCompletedChallengePageNo:
            return .get
        case .modifiyChallenge, .completeChallenge:
            return .put
        case .removeChallenge:
            return .delete
        }
    }
    
    var header: [String : String] {
        switch self {
        case .addChallenge(let accessToken, challenge: _),
                .getChallenge(accessToken: let accessToken, index: _),
                .modifiyChallenge(accessToken: let accessToken, challenge: _),
                .removeChallenge(accessToken: let accessToken, index: _),
                .completeChallenge(accessToken: let accessToken, index: _),
                .getChallengeCount(accessToken: let accessToken),
                .getOngoingChallengeList(accessToken: let accessToken, pageNo: _),
                .getLatestOngingChallengePageNo(accessToken: let accessToken),
                .getCompletedChallengeList(accessToken: let accessToken, pageNo: _),
                .getLatestCompletedChallengePageNo(accessToken: let accessToken):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(accessToken)"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .addChallenge(accessToken: _, challenge: let challenge):
            return ["title": challenge.title,
                    "deadline": challenge.deadline,
                    "content": challenge.content]
        case .modifiyChallenge(accessToken: _, challenge: let challenge):
            return ["index": challenge.index!,
                    "title": challenge.title,
                    "deadline": challenge.deadline,
                    "content": challenge.content]
        case .removeChallenge(accessToken: _, index: let index),
                .completeChallenge(accessToken: _, index: let index):
            return ["index": index]
        case .getOngoingChallengeList(accessToken: _, pageNo: let pageNo),
                .getCompletedChallengeList(accessToken: _, pageNo: let pageNo):
            return ["pageNo": pageNo.pageNo]
        case .getChallenge, .getChallengeCount, .getLatestOngingChallengePageNo, .getLatestCompletedChallengePageNo:
            return nil
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .addChallenge, .modifiyChallenge,  .removeChallenge, .getChallenge, .completeChallenge,
                .getChallengeCount, .getOngoingChallengeList, .getLatestOngingChallengePageNo,
                .getCompletedChallengeList, .getLatestCompletedChallengePageNo:
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
