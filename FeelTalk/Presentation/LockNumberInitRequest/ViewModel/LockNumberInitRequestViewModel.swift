//
//  LockNumberInitRequestViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/16.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class LockNumberInitRequestViewModel {
    private weak var coordinator: LockNumberInitRequestCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
        let dismissButtonTapObserver: ControlEvent<Void>
        let requestButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let popToastMessage = PublishRelay<String>()
    }
    
    init(coordinator: LockNumberInitRequestCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output{
        let output = Output()
        
        input.dismissButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        input.requestButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                Task {
                    let isSuccess = await vm.sendResetPartnerPasswordChat()
                    
                    DispatchQueue.main.async {
                        if (isSuccess) {
                            vm.coordinator?.dismiss()
                        } else {
                            output.popToastMessage.accept("에러가 발생했습니다. 잠시 후 다시 시도해 주세요.")
                        }
                    }
                }
            }.disposed(by: disposeBag)
        
        return output
    }
    
    
    private func sendResetPartnerPasswordChat() async -> Bool {
        return await withCheckedContinuation({ continuation in
            Task {
                guard let url = URL(string: ClonectAPI.BASE_URL + "/api/v1/chatting-message/reset-partner-password") else {
                    continuation.resume(returning: false)
                    return
                }
                
                var request = URLRequest(url: url)
                request.method = .post
                request.headers = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])
                guard let urlRequest = try? JSONEncoding().encode(request, with: [:]) else {
                    continuation.resume(returning: false)
                    return
                }
                
                AF.request(
                    urlRequest,
                    interceptor: DefaultRequestInterceptor()
                )
                .responseDecodable(of: BaseResponseDTO<SendResetPartnerPasswordChatResponse?>.self) { response in
                    switch response.result {
                    case .success(let data):
                        if data.status == "success" {
                            continuation.resume(returning: true)
                        } else {
                            continuation.resume(returning: false)
                        }
                    case .failure(_):
                        continuation.resume(returning: false)
                    }
                }
            }
        })
    }
    
    struct SendResetPartnerPasswordChatResponse: Decodable {
        let index: Int
        let pageIndex: Int
        let isRead: Bool
        let createAt: String
    }
}
