//
//  LoginViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseMessaging
import Alamofire

class LoginViewModel {
    private weak var coordinator: LoginCoordinator?
    private let loginUseCase: LoginUseCase
    private let disposeBag = DisposeBag()
    
    private let snsLogin = PublishRelay<SNSLogin01>()

    struct Input {
        let tapAppleLoginButton: ControlEvent<Void>
        let tapGoogleLoginButton: ControlEvent<Void>
        let tapKakaoLoginButton: ControlEvent<Void>
        let tapNaverLoginButton: ControlEvent<Void>
        let tapInquiryButton: ControlEvent<Void>
    }
    
    struct Output { }

    init(coordinator: LoginCoordinator?, loginUseCase: LoginUseCase) {
        self.coordinator = coordinator
        self.loginUseCase = loginUseCase
    }
    
    func transfer(input: Input) -> Output {
        Observable
            .merge([
                input.tapAppleLoginButton.map { SNSType.apple },
                input.tapGoogleLoginButton.map { SNSType.google },
                input.tapKakaoLoginButton.map { SNSType.kakao },
                input.tapNaverLoginButton.map { SNSType.naver }
            ]).withUnretained(self)
            .bind { vm, snsType in
                switch snsType {
                case .apple:
                    vm.loginUseCase.appleLogin()
                        .bind(to: vm.snsLogin)
                        .disposed(by: vm.disposeBag)
                case .google:
                    vm.loginUseCase.googleLogin()
                        .asObservable()
                        .bind(to: vm.snsLogin)
                        .disposed(by: vm.disposeBag)
                case .kakao:
                    vm.loginUseCase.kakaoLogin()
                        .asObservable()
                        .bind(to: vm.snsLogin)
                        .disposed(by: vm.disposeBag)
                case .naver:
                    vm.loginUseCase.naverLogin()
                        .bind(to: vm.snsLogin)
                        .disposed(by: vm.disposeBag)
                }
            }.disposed(by: disposeBag)
        
        snsLogin
            .withUnretained(self)
            .bind { vm, data in
                vm.loginUseCase.login(data)
                    .withUnretained(vm)
                    .bind(onNext: { vm, state in
                        switch state {
                        case .couple:
                            Task {
                                do {
                                    try await vm.updateFcmToken()
                                    DispatchQueue.main.async {
                                        vm.coordinator?.finish()
                                    }
                                } catch {
                                    return
                                }
                            }
                        case .newbie:
                            vm.coordinator?.showSignUpFlow()
                        case .solo:
                            Task {
                                do {
                                    try await vm.updateFcmToken()
                                    DispatchQueue.main.async {
                                        vm.coordinator?.showInviteCodeFlow()
                                    }
                                } catch {
                                    return
                                }
                            }
                        }
                    }).disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.tapInquiryButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showInquiryFlow()
            }.disposed(by: disposeBag)
        
        return Output()
    }
    
    func updateFcmToken() async throws {
        return try await withCheckedThrowingContinuation({ continuation in
            Task {
                let fcmToken = KeychainRepository.getItem(key: "fcmToken") as? String ?? Messaging.messaging().fcmToken
                
                guard let url = URL(string: ClonectAPI.BASE_URL + "/api/v1/member/fcm-token") else {
                    continuation.resume(throwing: NSError(domain: "URL parsing error", code: 400))
                    return
                }
                
                var request = URLRequest(url: url)
                request.method = .put
                request.headers = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])
                guard let urlRequest = try? JSONEncoding().encode(request, with: ["fcmToken": fcmToken]) else {
                    continuation.resume(throwing: NSError(domain: "Request json encoding error", code: 400))
                    return
                }
                
                AF.request(
                    urlRequest,
                    interceptor: DefaultRequestInterceptor()
                )
                .responseDecodable(of: BaseResponseDTO<LoginResponseDTO?>.self) { response in
                    switch response.result {
                    case .success(let data):
                        if data.status == "success" {
                            continuation.resume()
                        } else {
                            let message = data.message ?? "error occurred but no error message"
                            continuation.resume(throwing: NSError(domain: message, code: 400))
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        })
    }
}
