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
    let appleLogin = PublishSubject<SNSLogin01>()
    
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
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            appleLogin.onNext(.init(oauthId: userIdentifier,
                                    snsType: SNSType.apple.rawValue))
            
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            
        default:
            break
        }
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authData = appleIDCredential.authorizationCode,
              let _ = String(data: authData, encoding: .utf8) else { return }
    }
    
    /// Apple login fail
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In Error: \(error.localizedDescription)")
    }
}
