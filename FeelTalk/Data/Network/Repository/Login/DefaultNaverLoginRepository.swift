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

class DefaultNaverLoginRepository: NSObject, NaverRepository {
    private let disposeBag = DisposeBag()
    let snsLoginInfo = PublishSubject<SNSLogin01>()
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
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
        
        getInfo()
            .bind(to: snsLoginInfo)
            .disposed(by: disposeBag)
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() { print("리프레시 토큰") }
    
    func oauth20ConnectionDidFinishDeleteToken() { print("[SUCCESS] Naver logout") }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("---ERROR: \(error.localizedDescription)---")
    }
}

extension DefaultNaverLoginRepository {
    func getInfo() -> Observable<SNSLogin01> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let isValidAccessToken = self.loginInstance?.isValidAccessTokenExpireTimeNow() else { return Disposables.create() }
            
            if !isValidAccessToken { return Disposables.create() }
            
            guard let tokenType = self.loginInstance?.tokenType,
                  let accessToken = self.loginInstance?.accessToken else { return Disposables.create() }
            
            let urlStr = "https://openapi.naver.com/v1/nid/me"
            let url = URL(string: urlStr)!
            let authorization = "\(tokenType) \(accessToken)"
            
            let request = AF.request(url,
                                     method: .get,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: ["Authorization": authorization])
            
            request.responseDecodable(of: NaverLoginResponseDTO.self) { response in
                switch response.result {
                case .success(let responseDTO):
                    observer.onNext(responseDTO.toDomain())
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
