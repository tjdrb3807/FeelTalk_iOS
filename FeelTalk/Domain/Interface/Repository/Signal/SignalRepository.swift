//
//  SignalRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/03.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignalRepository {
    func getMySignal(accessToken: String) -> Single<Signal>
    
    func getPartnerSignal(accessToken: String) -> Single<Signal>
    
    func changeMySignal(accessToken: String, requestDTO: ChangeMySignalRequestDTO) -> Single<Bool>
}
