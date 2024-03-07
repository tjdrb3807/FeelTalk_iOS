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
    func getMySignal() -> Single<Signal>
    
    func getPartnerSignal() -> Single<Signal>
    
    func changeMySignal(requestDTO: ChangeMySignalRequestDTO) -> Single<Bool>
}
