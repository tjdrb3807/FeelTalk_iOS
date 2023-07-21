//
//  DefaultNaverLoginRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/11.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire
import RxSwift
import RxCocoa

enum NaverLoginError: Error {
    case refreshToeknError
}

class DefaultNaverLoginRepository: NSObject, NaverRepository {
    private let disposeBag = DisposeBag()

//    let refreshToken = PublishSubject<String>()
    let snsLoginInfo = PublishSubject<SNSLogin>()
    
    func login() {
        debugPrint("[CALL]: LoginRepository - naverLogin()")
        
        guard let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
        
        // TEST 과정에서는 토큰 지우고 초기화 상태에서 시작
        naverInstance.resetToken()
        
        naverInstance.delegate = self
        naverInstance.requestThirdPartyLogin()
    }
}

extension DefaultNaverLoginRepository: NaverThirdPartyLoginConnectionDelegate {
        func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
            debugPrint("[SUCCESS]: Naver login")
            
//            getRefreshToken()
//                .bind(to: refreshToken)
//                .disposed(by: disposeBag)
            getSNSLoginInfo()
                .bind(to: snsLoginInfo)
                .disposed(by: disposeBag)
         }
         
         func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() { print("리프레시 토큰") }
         func oauth20ConnectionDidFinishDeleteToken() { print("로그아웃") }
         
         // 모든 에러 처리
         func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
             print("---ERROR: \(error.localizedDescription)---")
         }
}

extension DefaultNaverLoginRepository {
    func getRefreshToken() -> Observable<String> {
        return Observable.create { observer -> Disposable in
            guard let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance() else { return Disposables.create() }
            guard let refreshToken = naverInstance.refreshToken else { return Disposables.create() }
            
            observer.onNext(refreshToken)
            
            return Disposables.create()
        }
    }
    
    func getSNSLoginInfo() -> Observable<SNSLogin> {
        return Observable.create { observer -> Disposable in
            guard let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance() else { return Disposables.create() }
            guard let refreshToken = naverInstance.refreshToken else { return Disposables.create() }
            
            observer.onNext(.init(snsType: .naver,
                                  refreshToken: refreshToken,
                                  authCode: nil,
                                  idToken: nil,
                                  authorizationCode: nil))
            
            return Disposables.create()
        }
    }
}
