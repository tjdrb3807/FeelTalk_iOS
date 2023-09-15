//
//  QuestionAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/26.
//

import Foundation
import Alamofire

enum QuestionAPI {
    case getLatestQuestionPageNo(accessToken: String)
    case getTodayQuestion(accessToken: String)
    case getQuestionList(accessToken: String, questionPage: QuestionPage)
    case getQuestion(accessToken: String, index: Int)
    case answerQuestion(accessToken: String, answer: QuestionAnswer)
    case preseForAnswer(accessToken: String, index: Int)
}

extension QuestionAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .getLatestQuestionPageNo:
            return "/api/v1/couple-question/last/page-no"
        case .getTodayQuestion:
            return "/api/v1/couple-question/today"
        case .getQuestionList:
            return "/api/v1/couple-questions"
        case .getQuestion(accessToken: _, index: let index):
            return "/api/v1/couple-question/\(index)"
        case .answerQuestion:
            return "/api/v1/couple-question"
        case .preseForAnswer:
            return "/api/v1/couple-question/chase-up"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getLatestQuestionPageNo, .getTodayQuestion, .getQuestion:
            return .get
        case .getQuestionList, .preseForAnswer:
            return .post
        case .answerQuestion:
            return .put
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getLatestQuestionPageNo(accessToken: let accessToken),
                .getTodayQuestion(accessToken: let accessToken),
                .getQuestionList(accessToken: let accessToken, questionPage: _),
                .getQuestion(accessToken: let accessToken, index: _),
                .answerQuestion(accessToken: let accessToken, answer: _),
                .preseForAnswer(accessToken: let accessToken, index: _):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(accessToken)"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getLatestQuestionPageNo, .getTodayQuestion, .getQuestion:
            return nil
        case .getQuestionList(accessToken: _, questionPage: let questionPage):
            return ["pageNo": questionPage.pageNo]
        case .answerQuestion(accessToken: _, answer: let answer):
            return ["index": answer.index,
                    "myAnswer": answer.myAnswer]
        case .preseForAnswer(accessToken: _, index: let index):
            return ["index": index]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .getLatestQuestionPageNo, .getTodayQuestion, .getQuestionList, .getQuestion, .answerQuestion, .preseForAnswer:
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
