//
//  ConfigurationUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol ConfigurationUseCase {
    func getConfigurationInfo() -> Observable<ConfigurationInfo>
    
    func commnent(with data: InquiryOrSuggestions) -> Observable<Bool>
    
    func getNowVersion() -> Observable<String>
    
    func getServiceDataTotalCount() -> Observable<ServiceDataCount>
    
    func getLockNubmer() -> Observable<String>
    
    func setLockNumber(_ setting: LockNumberSettings) -> Observable<Bool>
    
    func setUnlock()
    
    func resetLockNumber(_ lockNumber: String) -> Observable<Bool>
    
    func getLockNumberHintType() -> Observable<LockNumberHintType>
}

final class DefaultConfigurationUseCase: ConfigurationUseCase {
    private let configurationRepository: ConfigurationRepository
    private let disposeBag = DisposeBag()
    
    init(configurationRepository: ConfigurationRepository) {
        self.configurationRepository = configurationRepository
    }
    
    func getConfigurationInfo() -> Observable<ConfigurationInfo> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            configurationRepository
                .getConfigurationInfo()
                .asObservable()
                .bind(onNext: { info in
                    observer.onNext(info)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func commnent(with data: InquiryOrSuggestions) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            configurationRepository.comment(with: data)
                .asObservable()
                .bind(onNext: { isSuccess in
                    observer.onNext(isSuccess)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getNowVersion() -> Observable<String> {
        Observable.create { observer -> Disposable in
            guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return Disposables.create() }
            observer.onNext(version)
            
            return Disposables.create()
        }
    }
    
    func getServiceDataTotalCount() -> Observable<ServiceDataCount> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            configurationRepository.getServiceDataTotalCount()
                .asObservable()
                .bind(onNext: { data in
                    observer.onNext(data)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getLockNubmer() -> Observable<String> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            configurationRepository
                .getLockNumber()
                .asObservable()
                .subscribe(onNext: { lockNumber in
                    observer.onNext(lockNumber)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func setLockNumber(_ setting: LockNumberSettings) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            configurationRepository
                .setLockNumber(requestDTO: setting.toDTO())
                .asObservable()
                .filter { $0 }
                .subscribe(onNext: { _ in
                    observer.onNext(true)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func setUnlock() {
        configurationRepository
            .setUnlock()
            .filter { $0 }
            .map { result -> Bool in false }
            .asObservable()
            .bind(to: DefaultAppCoordinator.isLockScreenObserver)
            .disposed(by: disposeBag)
    }
    
    func resetLockNumber(_ lockNumber: String) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            configurationRepository
                .resetLockNumber(lockNumber)
                .asObservable()
                .filter { $0 }
                .subscribe(onNext: { result in
                    observer.onNext(result)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getLockNumberHintType() -> Observable<LockNumberHintType> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            configurationRepository
                .getLockNumberHintType()
                .asObservable()
                .subscribe(onNext: { type in
                    observer.onNext(type)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
