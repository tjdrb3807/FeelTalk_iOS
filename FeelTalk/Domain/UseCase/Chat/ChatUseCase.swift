//
//  ChatUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/14.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChatUseCase {
    func getLastPageNo() -> Observable<Int>
}

final class DefaultChatUseCase: ChatUseCase {
    private let chatRepository: ChatRepository
    private let disposeBag = DisposeBag()
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func getLastPageNo() -> Observable<Int> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            chatRepository.getLastPageNo(accessToken: accessToken)
                .asObservable()
                .bind(onNext: { data in
                    observer.onNext(data)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
