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
    func getConfigurationInfo(accessToken: String) -> Single<ConfigurationInfo>
    
    func comment(accessToken: String, with data: InquiryOrSuggestions) -> Single<Bool>
    
    func getServiceDataTotalCount(accessToken: String) -> Single<ServiceDataCount>
}
