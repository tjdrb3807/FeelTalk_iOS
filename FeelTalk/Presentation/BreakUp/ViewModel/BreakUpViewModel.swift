//
//  BreakUpViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import FirebaseMessaging

final class BreakUpViewModel {
    weak var coordinator: BreakUpCoordinator?
    private var configurationUseCase: ConfigurationUseCase
    private let disposeBag = DisposeBag()
    
    let questionCount = PublishRelay<Int>()
    let challengeCount = PublishRelay<Int>()
    let terminationType = BehaviorRelay<TerminationType>(value: .breakUp)
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let navigationBarLeftButtonTapObserver: ControlEvent<Void>
        let onTapBreakUp: PublishRelay<Bool>
    }
    
    struct Output {
        let questionCount: PublishRelay<Int>
        let challengeCount: PublishRelay<Int>
        let terminationType: BehaviorRelay<TerminationType>
    }
    
    init(coordinator: BreakUpCoordinator, configurationUseCase: ConfigurationUseCase) {
        self.coordinator = coordinator
        self.configurationUseCase = configurationUseCase
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                vm.configurationUseCase.getServiceDataTotalCount()
                    .bind(onNext: { model in
                        vm.questionCount.accept(model.questionCount)
                        vm.challengeCount.accept(model.challengeCount)
                    }).disposed(by: vm.disposeBag)
                vm.terminationType.accept(.breakUp)
            }.disposed(by: disposeBag)
        
        input.navigationBarLeftButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        input.onTapBreakUp
            .withUnretained(self)
            .bind { vm, isBreakUp in
                Task {
                    let isSuccessful = await vm.breakUp()
                    if (isSuccessful) {
                        Messaging.messaging().deleteToken { error in
                            KeychainRepository.deleteItem(key: "accessToken")
                            KeychainRepository.deleteItem(key: "refreshToken")
                            KeychainRepository.deleteItem(key: "expiredTime")
                            KeychainRepository.deleteItem(key: "userState")
                            DispatchQueue.main.async {
                                vm.coordinator?.finish()
                            }
                        }
                    }
                }
            }.disposed(by: disposeBag)
        
        return Output(questionCount: self.questionCount,
                      challengeCount: self.challengeCount,
                      terminationType: self.terminationType)
    }
}

extension BreakUpViewModel {
    func breakUp() async -> Bool {
        return await withCheckedContinuation { continuation in
            Task {
                guard let url = URL(string: ClonectAPI.BASE_URL + "/api/v1/couple/breakup") else {
                    continuation.resume(returning: false)
                    return
                }
                
                var request = URLRequest(url: url)
                request.method = .post
                request.headers = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])
                
                AF.request(
                    request,
                    interceptor: DefaultRequestInterceptor()
                )
                .responseDecodable(of: BaseResponseDTO<NoDataResponseDTO?>.self) { response in
                    print("response: \(response.debugDescription)")
                    switch response.result {
                    case .success(let responseDTO):
                        if responseDTO.status == "success" {
                            continuation.resume(returning: true)
                        } else {
                            continuation.resume(returning: false)
                        }
                    case .failure(_):
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }
}
