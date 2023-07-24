//
//  AppleRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol AppleRepository {
    var loginCompleted: PublishRelay<SNSLogin> { get }
    
    func login()
}
