//
//  LockNumberHintType.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/05.
//

import Foundation

enum LockNumberHintType: String, CaseIterable {
    case treasure
    case celebrity
    case date
    case travel
    case bucketList
}

extension LockNumberHintType {
    func convertLabelText() -> String {
        switch self {
        case .treasure:
            return "내 보물 제1호는?"
        case .celebrity:
            return "내가 가장 좋아하는 연예인은?"
        case .date:
            return "추억하고 싶은 날짜가 있다면?"
        case .travel:
            return "꼭 가보고 싶은 여행지가 있다면?"
        case .bucketList:
            return "인생의 버킷리스트 1호는?"
        }
    }
}
