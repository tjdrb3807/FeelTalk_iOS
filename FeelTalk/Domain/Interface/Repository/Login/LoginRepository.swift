//
//  LoginRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginRepository {
    func autoLogin(accessToken: String) -> Single<String>
    
    func login(_ data: SNSLogin01) -> Single<Token01>
}

