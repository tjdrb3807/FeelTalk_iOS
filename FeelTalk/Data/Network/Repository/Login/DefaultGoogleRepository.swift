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
    func login() -> Single<SNSLogin01> {
        Single.create { observer -> Disposable in
            guard let viewController = UIApplication.getMostTopViewController() else { return Disposables.create() }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
                guard error == nil else { return }
                guard let signInResult = signInResult else { return }
                
                signInResult.user.refreshTokensIfNeeded { user, error in
                    guard error == nil else { return }
                    guard let oauthId = signInResult.user.userID else { return }
                    
                    observer(.success(SNSLogin01(oauthId: oauthId,
                                                 snsType: SNSType.google.rawValue)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func logOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
