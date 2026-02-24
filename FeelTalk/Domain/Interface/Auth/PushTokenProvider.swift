//
//  PushTokenProvider.swift
//  FeelTalk
//
//  Domain layer interface for push token(FCM etc).
//  Created by 전성규 on 2/24/26.
//

import Foundation
import RxSwift

protocol PushTokenProvider {
    /// Returns current push token if avalible
    func fetchToken() -> Single<String?>
    
    /// Deletes/invalidates push token on provider side
    func deleteToken() -> Single<Void>
}
