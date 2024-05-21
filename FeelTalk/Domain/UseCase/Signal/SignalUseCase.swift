//
//  SignalUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/03.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignalUseCase {
    func getMySignal() -> Observable<Signal>
    
    func getPartnerSignal() -> Observable<Signal>
    
    func changeMySignal(_ model: Signal) -> Observable<Bool>
}

final class DefaultSignalUseCase: SignalUseCase {
    private let signalRepositroy: SignalRepository
    
    private let disposeBag = DisposeBag()
    
    init(signalRepositroy: SignalRepository) {
        self.signalRepositroy = signalRepositroy
    }
    
    func getMySignal() -> Observable<Signal> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.signalRepositroy
                .getMySignal()
                .asObservable()
                .subscribe(onNext: { signal in
                    observer.onNext(signal)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getPartnerSignal() -> Observable<Signal> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.signalRepositroy
                .getPartnerSignal()
                .asObservable()
                .subscribe(onNext: { signal in
                    observer.onNext(signal)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func changeMySignal(_ model: Signal) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.signalRepositroy
                .changeMySignal(requestDTO: model.toDTO())
                .asObservable()
                .subscribe(onNext: { event in
                    observer.onNext(event)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
