//
//  ChatRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChatRepository {
    func sendTextChat(accessToken: String, message: String) -> Single<Bool>
    
    func getLatestChatPageNo(accessToken: String) -> Single<Int>
}
