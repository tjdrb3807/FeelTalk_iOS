//
//  ChatUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChatUseCase {
    func sendTextChat(message: String) -> Observable<Bool>
    
    func getLatestChatPageNo() -> Observable<Int>
}

final class DefaultChatUseCase: ChatUseCase {
    private let chatRepository: ChatRepository
    private let disposeBag = DisposeBag()
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func sendTextChat(message: String) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            chatRepository.sendTextChat(accessToken: accessToken, message: message)
                .asObservable()
                .bind(onNext: { result in
                    observer.onNext(result)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getLatestChatPageNo() -> Observable<Int> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            chatRepository.getLatestChatPageNo(accessToken: accessToken)
                .asObservable()
                .bind(onNext: { pageNo in
                    observer.onNext(pageNo)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
