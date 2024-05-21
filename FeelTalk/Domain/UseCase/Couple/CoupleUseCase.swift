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
    func registerInviteCode(_ code: String) -> Single<Bool>
}

final class DefaultCoupleUaseCase: CoupleUseCase {
    private let coupleRepository: CoupleRepository
    
    private let disposeBag = DisposeBag()
    
    init(coupleRepository: CoupleRepository) {
        self.coupleRepository = coupleRepository
    }
    
    func registerInviteCode(_ code: String) -> Single<Bool> {
        return Single.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create()}
            
            self.coupleRepository
                .registerInviteCode(inviteCode: code)
                .subscribe(onSuccess: { observer(.success($0)) },
                           onFailure: { observer(.failure($0)) },
                           onDisposed: nil)
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
