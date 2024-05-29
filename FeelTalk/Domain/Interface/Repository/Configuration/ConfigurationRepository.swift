//
//  ConfigurationRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol ConfigurationRepository {
    func getConfigurationInfo() -> Single<ConfigurationInfo>
    
    func comment(with data: InquiryOrSuggestions) -> Single<Bool>
    
    func getServiceDataTotalCount() -> Single<ServiceDataCount>
    
    func getLockNumber() -> Single<String?>
    
    func setLockNumber(requestDTO: LockNumberSettingsRequestDTO) -> Single<Bool>
    
    func setUnlock() -> Single<Bool>
    
    func resetLockNumber(_ lockNumber: String) -> Single<Bool>
    
    func getLockNumberHintType() -> Single<LockNumberHintType>
}
