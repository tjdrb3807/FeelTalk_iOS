//
//  SignUpRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/06.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpRepository {
    func signUp(snsType: SNSType,
                nickname: String,
                refreshToken: String?,
                authCode: String?,
                idToken: String?,
                state: String?,
                authorizationCode: String?,
                fcmToken: String,
                marketingConsent: Bool) -> Single<Token>
    
    func getAuthNumber(_ requestDTO: AuthNumberRequestDTO) -> Single<Bool>
    
    func getReAuthNumber(_ requestDTO: ReAuthNumberRequestDTO) -> Single<Bool>
}
