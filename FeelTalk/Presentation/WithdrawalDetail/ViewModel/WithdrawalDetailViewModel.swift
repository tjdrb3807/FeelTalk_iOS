//
//  WithdrawalDetailViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard
import Alamofire

final class WithdrawalDetailViewModel {
    private weak var coordinator: WithdrawalDetailCoordinator?
    private let disposeBag = DisposeBag()
    
    private let itemTypes = BehaviorRelay<[WithdrawalReasonsType]>(value: [.breakUp, .noFunction, .bugOrError, .etc])
    private let selectedReasonObserver = PublishRelay<WithdrawalReasonsType>()
    private let etcReason = BehaviorRelay<String?>(value: nil)
    private let deleteReason = BehaviorRelay<String?>(value: nil)
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let cellTapObserver: Observable<WithdrawalReasonsType>
        let popButtonTapObserver: ControlEvent<Void>
        let withdrawalButtonTapObserver: ControlEvent<Void>
        let tapAlertConfirm: PublishRelay<Bool>
        let etcReason: BehaviorRelay<String?>
        let deleteReason: BehaviorRelay<String?>
    }
    
    struct Output {
        let items = PublishRelay<[WithdrawalReasonsType]>()
        let selectedCell = PublishRelay<WithdrawalReasonsType>()
        let withdrawalButtonState = PublishRelay<Bool>()
        let popUpAlert = PublishRelay<CustomAlertType>()
        let keyboardHeight = PublishRelay<CGFloat>()
        let etcReason: BehaviorRelay<String?>
        let deleteReason: BehaviorRelay<String?>
    }
    
    init(coordinator: WithdrawalDetailCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        let output = Output(
            etcReason: self.etcReason,
            deleteReason: self.deleteReason
        )
        
        input.viewWillAppear
            .asObservable()
            .withLatestFrom(itemTypes)
            .bind(to: output.items)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .asObservable()
            .map { _ -> WithdrawalReasonsType in .none }
            .bind(to: selectedReasonObserver)
            .disposed(by: disposeBag)
        
        input.cellTapObserver
            .bind(to: selectedReasonObserver)
            .disposed(by: disposeBag)
        
        // NavigationController pop
        input.popButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        input.withdrawalButtonTapObserver
            .asObservable()
            .map { _ -> CustomAlertType in .withdrawal }
            .bind(to: output.popUpAlert)
            .disposed(by: disposeBag)
        
        selectedReasonObserver
            .withLatestFrom(self.deleteReason, resultSelector: {
                (type: $0, deleteReason: $1)
            })
            .withLatestFrom(self.etcReason, resultSelector: { data, etcReason in
                (type: data.type, deleteReason: data.deleteReason, etcReason: etcReason)
            })
            .map { data -> Bool in
                var state = true
                if (data.type == .none) {
                    state = false
                }
                if data.type == .etc && data.etcReason?.isEmpty != false {
                    state = false
                }
                if data.deleteReason?.isEmpty != false {
                    state = false
                }
                return state
            }
            .bind(to: output.withdrawalButtonState)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0.0 <= $0 }
            .bind(to: output.keyboardHeight)
            .disposed(by: disposeBag)
        
        input.etcReason
            .withLatestFrom(selectedReasonObserver, resultSelector: {
                (etcReason: $0, type: $1)
            })
            .withUnretained(self)
            .bind(onNext: { vm, data in
                var state: Bool = true
                if (data.type == .none) {
                    state = false
                }
                if data.type == .etc && data.etcReason?.isEmpty != false {
                    state = false
                }
                if vm.deleteReason.value?.isEmpty != false {
                    state = false
                }
                output.withdrawalButtonState.accept(state)
                vm.etcReason.accept(data.etcReason)
            })
            .disposed(by: disposeBag)
        
        input.deleteReason
            .withLatestFrom(selectedReasonObserver, resultSelector: {
                (deleteReason: $0, type: $1)
            })
            .withUnretained(self)
            .bind(onNext: { vm, data in
                var state: Bool = true
                if (data.type == .none) {
                    state = false
                }
                if data.type == .etc && vm.etcReason.value?.isEmpty != false {
                    state = false
                }
                if data.deleteReason?.isEmpty != false {
                    state = false
                }
                output.withdrawalButtonState.accept(state)
                vm.deleteReason.accept(data.deleteReason)
            })
            .disposed(by: disposeBag)
        
        input.tapAlertConfirm
            .withLatestFrom(self.deleteReason)
            .withLatestFrom(self.etcReason) {
                (deleteReason: $0,  etcReason: $1)
            }
            .withLatestFrom(self.selectedReasonObserver, resultSelector: {
                (category: $1, deleteReason: $0.deleteReason, etcReason: $0.etcReason)
            })
            .withUnretained(self)
            .bind(onNext: { vm, data in
                guard let deleteReason = data.deleteReason else { return }

                Task {
                    var etcReason: String? = nil
                    let category: String
                    switch data.category {
                    case .breakUp:
                        category = "breakUp"
                    case .noFunction:
                        category = "noFunctionality"
                    case .bugOrError:
                        category = "bugOrError"
                    case .etc:
                        category = "etc"
                        etcReason = data.etcReason
                    case .none:
                        return
                    }
                    let isSuccessful = await vm.deleteAccount(
                        category: category,
                        etcReason: etcReason,
                        deleteReason: deleteReason
                    )

                    if (isSuccessful) {
                        KeychainRepository.deleteItem(key: "accessToken")
                        KeychainRepository.deleteItem(key: "refreshToken")
                        KeychainRepository.deleteItem(key: "expiredTime")
                        KeychainRepository.deleteItem(key: "userState")
                        DispatchQueue.main.async {
                            vm.coordinator?.finish()
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension WithdrawalDetailViewModel {
    func deleteAccount(
        category: String,
        etcReason: String?,
        deleteReason: String
    ) async -> Bool {
        return await withCheckedContinuation { continuation in
            Task {
                guard let url = URL(string: ClonectAPI.BASE_URL + "/api/v1/withdraw") else {
                    continuation.resume(returning: false)
                    return
                }
                
                var request = URLRequest(url: url)
                request.method = .delete
                request.headers = HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"])
                guard let urlRequest = try? JSONEncoding().encode(request, with: ["category": category, "etcReason": etcReason, "deleteReason": deleteReason]) else {
                    continuation.resume(returning: false)
                    return
                }
                
                AF.request(
                    urlRequest,
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
