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
    func getMyInfo() -> Observable<MyInfo>
    
    func getPartnerInfo() -> Observable<PartnerInfo>
}

final class DefaultUserUseCase: UserUseCase {
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getMyInfo() -> Observable<MyInfo> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String  else { return Disposables.create() }
            userRepository.getMyInfo(accessToken: accessToken)
                .asObservable()
                .bind(onNext: { info in
                    observer.onNext(info)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getPartnerInfo() -> Observable<PartnerInfo> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            userRepository.getPartnerInfo(accessToken: accessToken)
                .asObservable()
                .bind(onNext: { info in
                    observer.onNext(info)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
