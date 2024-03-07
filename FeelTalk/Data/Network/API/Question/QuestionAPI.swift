//
//  QuestionAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/26.
//

import Foundation
import Alamofire

enum QuestionAPI {
    case answerQuestion(requestDTO: AnswerQuestionRequestDTO)
    case getLatestQuestionPageNo
    case getQuestion(index: Int)
    case getQuestionList(questionPage: QuestionPage)
    case getTodayQuestion
    case pressForAnswer(requestDTO: PressForAnswerRequestDTO)
}

extension QuestionAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .answerQuestion:
            return "/api/v1/couple-question"
        case .getLatestQuestionPageNo:
            return "/api/v1/couple-question/last/page-no"
        case .getQuestion(index: let index):
            return "/api/v1/couple-question/\(index)"
        case .getQuestionList:
            return "/api/v1/couple-questions"
        case .getTodayQuestion:
            return "/api/v1/couple-question/today"
        case .pressForAnswer:
            return "/api/v1/couple-question/chase-up"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .answerQuestion:
            return .put
        case .getLatestQuestionPageNo, .getQuestion, .getTodayQuestion:
            return .get
        case .getQuestionList, .pressForAnswer:
            return .post
        }
    }
    
    var header: [String : String] {
        switch self {
        case .answerQuestion,
                .getLatestQuestionPageNo,
                .getQuestion,
                .getQuestionList,
                .getTodayQuestion,
                .pressForAnswer:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .answerQuestion(requestDTO: let requestDTO):
            return ["index": requestDTO.index,
                    "myAnswer": requestDTO.myAnswer]
        case .getLatestQuestionPageNo, .getQuestion, .getTodayQuestion:
            return nil
        case .getQuestionList(questionPage: let questionPage):
            return ["pageNo": questionPage.pageNo]
        case .pressForAnswer(requestDTO: let requestDTO):
            return ["index": requestDTO.index]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .answerQuestion,
                .getLatestQuestionPageNo,
                .getQuestion,
                .getQuestionList,
                .getTodayQuestion,
                .pressForAnswer:
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
