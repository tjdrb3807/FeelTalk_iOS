//
//  CoupleUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import Foundation
import RxSwift
import RxCocoa

protocol CoupleUseCase {
    func getInviteCode() -> Observable<String>
    func registerInviteCode(_ code: String)
}

final class DefaultCoupleUaseCase: CoupleUseCase {
    private let coupleRepository: CoupleRepository
    private let authRepository: AuthRepository
    
    private let disposeBag = DisposeBag()
    
    init(coupleRepository: CoupleRepository,
         authRepository: AuthRepository) {
        self.coupleRepository = coupleRepository
        self.authRepository = authRepository
    }
    
    func getInviteCode() -> Observable<String> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            
            coupleRepository.getInviteCode(accessToken: accessToken)
                .asObservable()
                .bind(to: observer)
                .disposed(by: disposeBag)
    
            return Disposables.create()
        }
    }
    
    func registerInviteCode(_ code: String) {
        guard let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return }
        
        coupleRepository.registerInviteCode(accessToken: accessToken, inviteCode: code)
    }
}
