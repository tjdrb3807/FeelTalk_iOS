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
}

final class DefaultConfigurationUseCase: ConfigurationUseCase {
    private let configurationRepository: ConfigurationRepository
    private let disposeBag = DisposeBag()
    
    init(configurationRepository: ConfigurationRepository) {
        self.configurationRepository = configurationRepository
    }
    
    func getConfigurationInfo() -> Observable<ConfigurationInfo> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            configurationRepository.getConfigurationInfo(accessToken: accessToken)
                .asObservable()
                .bind(onNext: { info in
                    observer.onNext(info)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func commnent(with data: InquiryOrSuggestions) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            configurationRepository.comment(accessToken: accessToken, with: data)
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
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            configurationRepository.getServiceDataTotalCount(accessToken: accessToken)
                .asObservable()
                .bind(onNext: { data in
                    observer.onNext(data)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}
