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
    func completeChallenge(index: Int) -> Observable<Bool>
    
    func getChallenge(index: Int) -> Observable<Challenge>
    
    func getChallengeCount() -> Observable<ChallengeCount>
    
    func getChallengeLatestPageNo(type: ChallengeState) -> Observable<Int>
    
    func getChallengeList(type: ChallengeState, pageNo: Int) -> Observable<[Challenge]>
    
    func removeChallenge(index: Int) -> Observable<Bool>
}

final class DefaultChallengeUseCase: ChallengeUseCase {
    private let challengeRepository: ChallengeRepository
    private let disposeBag = DisposeBag()
    
    init(challengeRepository: ChallengeRepository) {
        self.challengeRepository = challengeRepository
    }
    
    func completeChallenge(index: Int) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            challengeRepository.completeChallenge(accessToken: accessToken, index: index)
                .asObservable()
                .bind(onNext: { isSuccess in
                    observer.onNext(isSuccess)
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
    
    func removeChallenge(index: Int) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            challengeRepository.removeChallenge(accessToken: accessToken, index: index)
                .asObservable()
                .bind(onNext: { isSuccess in
                    observer.onNext(isSuccess)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
