//
//  ChatRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/14.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChatRepository {
    func getLastPageNo() -> Single<Int>
    
    func getChatList(pageNo: Int) -> Single<[Chat]>
}
