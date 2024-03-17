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
    
    func sendTextChat(text: String) -> Observable<TextChat>
    
    func sendImageChat(image: UIImage) -> Observable<ImageChat>
    
    func sendVoiceChat(audio: Data) -> Observable<VoiceChat>
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
            self.chatRepository
                .getLastPageNo()
                .asObservable()
                .bind(onNext: { data in
                    observer.onNext(data)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getChatList(pageNo: Int) -> Observable<[Chat]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.chatRepository
                .getChatList(pageNo: pageNo)
                .asObservable()
                .bind(onNext: {
                    print($0)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func sendTextChat(text: String) -> Observable<TextChat> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.chatRepository
                .sendTextChat(text: text)
                .asObservable()
                .bind(onNext: {
                    print($0)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func sendImageChat(image: UIImage) -> Observable<ImageChat> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.chatRepository
                .sendImageChat(image: image)
                .asObservable()
                .bind(onNext: {
                    print($0)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func sendVoiceChat(audio: Data) -> Observable<VoiceChat> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.chatRepository
                .sendVoiceChat(audio: audio)
                .asObservable()
                .bind(onNext: {
                    print($0)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
