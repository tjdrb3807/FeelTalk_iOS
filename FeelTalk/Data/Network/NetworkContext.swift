//
//  NetworkContext.swift
//  FeelTalk
//
//  Created by 전성규 on 1/16/26.
//

import Foundation

/// 네트워크 공통 설정을 담는 컨텍스트
/// 네트워크 레이어 전반에서 공유되는 환경 정보를 보관한다.
struct NetworkContext {
    let environment: APIEnvironment
}

/// 현재 실행 중인 네트워크 컨텍스트에 대한 전역 접근 지점
/// 앱 시작 시(SceneDelegate) 실행 환경에 따라 초기화된다.
final class NetworkContextHolder {
    private(set) static var shared = NetworkContext(environment: ProdAPIEnvironment())

    static func configure(_ context: NetworkContext) { shared = context }
}
