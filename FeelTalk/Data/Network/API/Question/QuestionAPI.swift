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
}

extension QuestionAPI: Router, URLRequestConvertible {
    var baseURL: String { ClonectAPI.BASE_URL }
    
    var path: String {
        switch self {
        case .getLatestQuestionPageNo:
            return "/api/v1/couple-question/last/page-no"
        case .getTodayQuestion:
            return "/api/v1/couple-question/recent"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getLatestQuestionPageNo, .getTodayQuestion:
            return .get
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getLatestQuestionPageNo(accessToken: let accessToken), .getTodayQuestion(accessToken: let accessToken):
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(accessToken)"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getLatestQuestionPageNo, .getTodayQuestion:
            return nil
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        switch self {
        case .getLatestQuestionPageNo, .getTodayQuestion:
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
