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
    func addChallenge(challenge: Challenge) -> Observable<Int>
    func modifiyChallenge(challenge: Challenge) -> Observable<Bool>
    func removeChallenge(index: Int) -> Observable<Bool>
    func getChallenge(index: Int) -> Observable<Challenge>
    func completeChallenge(index: Int) -> Observable<Bool>
    func getChallengeCount() -> Observable<ChallengeCount>
    func getOngoingChallengeList(pageNo: ChallengePage) -> Observable<[Challenge]>
    func getLatestOngoingChallengePageNo() -> Observable<ChallengePage>
    func getCompletedChallengeList(pageNo: ChallengePage) -> Observable<[Challenge]>
    func getLatestCompletedChallengePageNo() -> Observable<ChallengePage>
}

final class DefaultChallengeUseCase: ChallengeUseCase {
    private let challengeRepository: ChallengeRepository
    private let disposeBag = DisposeBag()
    
    init(challengeRepository: ChallengeRepository) {
        self.challengeRepository = challengeRepository
    }
    
    func addChallenge(challenge: Challenge) -> Observable<Int> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            challengeRepository.addChallenge(accessToken: accessToken, challenge: challenge)
                .asObservable()
                .bind(onNext: { index in
                    observer.onNext(index)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func modifiyChallenge(challenge: Challenge) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            challengeRepository.modifiyChallenge(accessToken: accessToken, challenge: challenge)
                .asObservable()
                .bind(onNext: { isSuccess in
                    observer.onNext(isSuccess)
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
    
    func getOngoingChallengeList(pageNo: ChallengePage) -> Observable<[Challenge]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            challengeRepository.getOngoingChallengeList(accessToken: accessToken, pageNo: pageNo)
                .asObservable()
                .bind(onNext: { list in
                    observer.onNext(list)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getLatestOngoingChallengePageNo() -> Observable<ChallengePage> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            challengeRepository.getLatestOngoingChallengePageNo(accessToken: accessToken)
                .asObservable()
                .bind(onNext: { pageNo in
                    observer.onNext(pageNo)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getCompletedChallengeList(pageNo: ChallengePage) -> Observable<[Challenge]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            challengeRepository.getCompletedChallengeList(accessToken: accessToken, pageNo: pageNo)
                .asObservable()
                .bind(onNext: { list in
                    observer.onNext(list)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getLatestCompletedChallengePageNo() -> Observable<ChallengePage> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            challengeRepository.getLatestCompletedChallengePageNo(accessToken: accessToken)
                .asObservable()
                .bind(onNext: { pageNo in
                    observer.onNext(pageNo)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
