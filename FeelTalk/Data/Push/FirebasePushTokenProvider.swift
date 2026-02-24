//
//  FirebasePushTokenProvider.swift
//  FeelTalk
//
//  Concrete implementation of PushTokenProvider.

//  Created by 전성규 on 2/24/26.
//

import Foundation
import RxSwift
import FirebaseMessaging

final class FirebasePushTokenProvider: PushTokenProvider {
    func fetchToken() -> Single<String?> {
        Single.create { single in
            let token = Messaging.messaging().fcmToken
            single(.success(token))
            
            return Disposables.create()
        }
    }
    
    func deleteToken() -> Single<Void> {
        Single.create { single in
            Messaging.messaging().deleteToken { error in
                if let error = error {
                    single(.failure(error))
                } else {
                    single(.success(()))
                }
            }
            
            return Disposables.create()
        }
    }
}
