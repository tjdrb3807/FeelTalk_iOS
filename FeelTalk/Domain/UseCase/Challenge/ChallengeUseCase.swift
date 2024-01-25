//
//  ChallengeUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChallengeUseCase {
    func addChallenge(model: (title: String, deadline: String, content: String)) -> Observable<ChallengeChat>
    
    func completeChallenge(index: Int) -> Observable<ChallengeChat>
    
    func getChallenge(index: Int) -> Observable<Challenge>
    
    func getChallengeCount() -> Observable<ChallengeCount>
    
    func getChallengeLatestPageNo(type: ChallengeState) -> Observable<Int>
    
    func getChallengeList(type: ChallengeState, pageNo: Int) -> Observable<[Challenge]>
    
    func modifyChallenge(model: (index: Int, title: String, deadline: String, content: String)) -> Observable<Bool>
    
    func removeChallenge(index: Int) -> Observable<Bool>
}

final class DefaultChallengeUseCase: ChallengeUseCase {
    private let challengeRepository: ChallengeRepository
    private let disposeBag = DisposeBag()
    
    init(challengeRepository: ChallengeRepository) {
        self.challengeRepository = challengeRepository
    }
    
    func addChallenge(model: (title: String, deadline: String, content: String)) -> Observable<ChallengeChat> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            
            challengeRepository.addChallenge(accessToken: accessToken,
                                             requestDTO: AddChallengeRequestDTO(title: model.title,
                                                                                deadline: model.deadline,
                                                                                content: model.content))
            .asObservable()
            .bind(onNext: { event in
                observer.onNext(event)
            }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func completeChallenge(index: Int) -> Observable<ChallengeChat> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            
            challengeRepository.completeChallenge(accessToken: accessToken,
                                                  requestDTO: CompleteChallengeRequestDTO(index: index))
            .asObservable()
            .bind(onNext: { event in
                observer.onNext(event)
            }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getChallenge(index: Int) -> Observable<Challenge> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            challengeRepository.getChallenge(accessToken: accessToken, index: index)
                .asObservable()
                .bind(onNext: { challenge in
                    observer.onNext(challenge)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getChallengeLatestPageNo(type: ChallengeState) -> Observable<Int> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            
            challengeRepository.getChallengeLatestPageNo(accessToken: accessToken, type: type)
                .asObservable()
                .map { $0.pageNo }
                .bind(onNext: {
                    observer.onNext($0)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getChallengeList(type: ChallengeState, pageNo: Int) -> Observable<[Challenge]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            
            challengeRepository.getChallengeList(accessToken: accessToken,
                                                 type: type,
                                                 requestDTO: ChallengeListRequestDTO(pageNo: pageNo))
            .asObservable()
            .bind(onNext: {
                observer.onNext($0)
            }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getChallengeCount() -> Observable<ChallengeCount> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            challengeRepository.getChallengeCount(accessToken: accessToken)
                .asObservable()
                .bind(onNext: { challengeCount in
                    observer.onNext(challengeCount)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func modifyChallenge(model: (index: Int, title: String, deadline: String, content: String)) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            
            challengeRepository.modifyChallenge(accessToken: accessToken,
                                                requestDTO: ModifyChallengeRequestDTO(index: model.index,
                                                                                      title: model.title,
                                                                                      deadline: model.deadline,
                                                                                      content: model.content))
            .asObservable()
            .bind(onNext: { event in
                observer.onNext(event)
            }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func removeChallenge(index: Int) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            
            challengeRepository.removeChallenge(accessToken: accessToken, requestDTO: RemoveChallengeRequestDTO(index: index))
                .asObservable()
                .bind(onNext: { evnet in
                    observer.onNext(evnet)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
