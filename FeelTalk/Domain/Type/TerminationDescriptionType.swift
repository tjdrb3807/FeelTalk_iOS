//
//  TerminationDescriptionType.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/06.
//

import Foundation

enum TerminationDescriptionType: String {
    case breakUpRemoveData = "연인과 쌓아 온 모든 데이터 및 개인정보가 사라져요"
    case breakUpRecoveryablePeriod = "재연결 및 데이터 복구 가능 기간은 30일이예요"
    case breakUpReconnect = "재연결 시, 해당 계정으로 로그인과 연결을 진행해야해요"
    
    case withdrawalRemoveData = "탈퇴 시 모든 데이터가 삭제되고 복구할 수 없어요"
    case withdrawalUnrecoverable = "동일한 계정으로 재가입해도 데이터를 복구할 수 없어요"
}
