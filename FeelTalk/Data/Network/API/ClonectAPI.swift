//
//  ClonectAPI.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/28.
//

import Foundation

/// 네트워크 환경을 추상화하기 위한 프로토콜
protocol APIEnvironment {
    /// 현재 실행 환경에서 사용할 Base URL
    var baseURL: String { get }
}

/// 운영(Production) 서버 환경 설정
final class ProdAPIEnvironment: APIEnvironment {
    var baseURL: String { "https://clonect.net" }
}
