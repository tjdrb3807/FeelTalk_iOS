//
//  UserUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/14.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserUseCase {
    func getInviteCode() -> Observable<String>
    
    func getMyInfo() -> Observable<MyInfo>
    
    func getPartnerInfo() -> Observable<PartnerInfo>
}

final class DefaultUserUseCase: UserUseCase {
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getInviteCode() -> Observable<String> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            userRepository
                .getInviteCode()
                .asObservable()
                .subscribe(onNext: { code in
                    observer.onNext(code)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getMyInfo() -> Observable<MyInfo> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            userRepository
                .getMyInfo()
                .asObservable()
                .bind(onNext: { info in
                    observer.onNext(info)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getPartnerInfo() -> Observable<PartnerInfo> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            userRepository
                .getPartnerInfo()
                .asObservable()
                .bind(onNext: { info in
                    observer.onNext(info)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
