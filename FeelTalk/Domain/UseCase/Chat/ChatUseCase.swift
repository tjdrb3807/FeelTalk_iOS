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
    
    func getChatList(pageNo: Int) -> Observable<[Chat]>
}

final class DefaultChatUseCase: ChatUseCase {
    private let chatRepository: ChatRepository
    private let disposeBag = DisposeBag()
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func getLastPageNo() -> Observable<Int> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            chatRepository
                .getLastPageNo()
                .asObservable()
                .bind(onNext: { data in
                    observer.onNext(data)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getChatList(pageNo: Int) -> Observable<[Chat]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            chatRepository
                .getChatList(pageNo: pageNo)
                .asObservable()
                .bind(onNext: {
                    print($0)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
