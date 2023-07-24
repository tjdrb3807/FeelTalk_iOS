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
    
    func reLogin(snsType: SNSType,
                 refreshToken: String?,
                 authCode: String?,
                 idToken: String?,
                 state: String?,
                 authorizationCode: String?) -> Single<Login>
}

