//
//  DefaultGoogleRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/24.
//

import Foundation
import GoogleSignIn
import RxSwift
import RxCocoa

final class DefaultGoogleRepository: GoogleRepository {
    func login() -> Single<SNSLogin> {
        return Single.create { observer -> Disposable in
            guard let viewController = UIApplication.getMostTopViewController() else { return Disposables.create() }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
                guard error == nil else { return }
                guard let signInResult = signInResult else { return }
                
                signInResult.user.refreshTokensIfNeeded { user, error in
                    guard error == nil else { return }
                    guard let user = user else { return }
                    
                    guard let idToken = user.idToken?.tokenString else { return }
                    
                    guard let authCode = signInResult.serverAuthCode else { return }
        
                    observer(.success(.init(snsType: .google,
                                            refreshToken: nil,
                                            authCode: authCode,
                                            idToken: idToken,
                                            authorizationCode: nil)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func logOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
