//
//  Router.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/28.
//

import Foundation
import Alamofire

public protocol Router {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String] { get }
    var parameters: [String: Any]? { get }
    var encoding: ParameterEncoding? { get }
}
