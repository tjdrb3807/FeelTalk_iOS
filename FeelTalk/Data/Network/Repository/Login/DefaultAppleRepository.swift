//
//  DefaultAppleRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/24.
//

import Foundation
import AuthenticationServices
import RxSwift
import RxCocoa

final class DefaultAppleRepository: NSObject, AppleRepository {
    let loginCompleted = PublishRelay<SNSLogin>()
    
    func login() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension DefaultAppleRepository: ASAuthorizationControllerDelegate {
    /// Apple login success
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let authData = appleIDCredential.authorizationCode,
           let authorizationCode = String(data: authData, encoding: .utf8) else { return }
        
        loginCompleted.accept(.init(snsType: .appleIOS,
                                    refreshToken: nil,
                                    authCode: nil,
                                    idToken: nil,
                                    authorizationCode: authorizationCode))
    }
    
    /// Apple login fail
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In Error: \(error.localizedDescription)")
    }
}
