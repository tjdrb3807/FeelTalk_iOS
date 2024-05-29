//
//  LockNumberPadViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/01.
//

import Foundation
import RxSwift
import RxCocoa

final class LockNumberPadViewModel {
    weak var coordinator: LockNumberPadCoordinator?
    private let configurationUseCase: ConfigurationUseCase
    private let disposeBag = DisposeBag()
    
    let viewType = ReplayRelay<LockNumberPadViewType>.create(bufferSize: 1)
    let setPasswordObserver = PublishRelay<String>()
    let crtPasswordObserver = BehaviorRelay<String?>(value: nil)
    let prePasswordObserver = BehaviorRelay<String?>(value: nil)
    
    struct Input {
        let viewWillAppearObserver: ControlEvent<Bool>
        let numberPadCellTapObserver: PublishRelay<NumberPadCellContentType>
        let hintButtonTapOberver: ControlEvent<Void>
    }
    
    struct Output {
        let viewType = PublishRelay<LockNumberPadViewType>()
        let titleLabelModel = PublishRelay<String>()
        let descriptionLabelType = PublishRelay<LockNumberPadViewDescriptionType?>()
        let passwordCount = PublishRelay<Int>()
    }
    
    init(coordinator: LockNumberPadCoordinator, configurationUseCase: ConfigurationUseCase) {
        self.coordinator = coordinator
        self.configurationUseCase = configurationUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppearObserver
            .asObservable()
            .withLatestFrom(viewType)
            .withUnretained(self)
            .bind { vm, type in
                if type == .access {
                    vm.configurationUseCase
                        .getLockNubmer()
                        .filter { $0 != nil }
                        .map { $0! }
                        .bind(to: vm.setPasswordObserver)
                        .disposed(by: vm.disposeBag)
                }
                output.viewType.accept(type)
                output.titleLabelModel.accept(type.rawValue)
                output.descriptionLabelType.accept(vm.convertToLockNumberPadViewDescriptionType(by: type))
            }.disposed(by: disposeBag)
        
        // 숫자 버튼을 눌렀을 경우
        input.numberPadCellTapObserver
            .filter { $0 != .cancel && $0 != .confirm}
            .map { $0.rawValue }
            .withUnretained(self)
            .map { vm, inputPW -> String in
                guard let crtPW = vm.crtPasswordObserver.value else { return inputPW }
                
                return crtPW.appending(inputPW)
            }.filter { $0.count <= 4 }
            .bind(to: crtPasswordObserver)
            .disposed(by: disposeBag)
        
        // 취소 버튼을 눌렀을 경우
        input.numberPadCellTapObserver
            .filter { $0 == .cancel }
            .withLatestFrom(viewType)
            .withUnretained(self)
            .bind { vm, type in
                guard let enterdPassword = vm.crtPasswordObserver.value else {
                    if type != .access { vm.coordinator?.dismiss() }
                    return
                }
                
                if enterdPassword.isEmpty {
                    switch type {
                    case .access:
                        break
                    default:
                        vm.coordinator?.dismiss()
                    }
                } else {
                    vm.crtPasswordObserver.accept(String(enterdPassword.dropLast(1)))
                }
            }.disposed(by: disposeBag)

        input.numberPadCellTapObserver
            .filter { $0 == .confirm }
            .withLatestFrom(viewType)
            .filter { $0 == .newSettings }
            .withLatestFrom(output.descriptionLabelType)
            .filter { $0 == .initPasswordInput || $0 == .differentPassword }
            .withLatestFrom(crtPasswordObserver)
            .compactMap { $0 }
            .filter { $0.count == 4 }
            .withUnretained(self)
            .bind { vm, crtPassword in
                vm.prePasswordObserver.accept(crtPassword)
                vm.crtPasswordObserver.accept("")   // 숫자 초기화
                vm.crtPasswordObserver.accept(nil)
                output.descriptionLabelType.accept(.onemoreInitPasswordInput)
            }.disposed(by: disposeBag)
        
        input.numberPadCellTapObserver
            .filter { $0 == .confirm }
            .withLatestFrom(viewType)
            .filter { $0 == .changePassword }
            .withLatestFrom(output.descriptionLabelType)
            .filter { $0 == .newPasswordInput || $0 == .differentPassword }
            .withLatestFrom(crtPasswordObserver)
            .compactMap { $0 }
            .filter { $0.count == 4 }
            .withUnretained(self)
            .bind { vm, crtPassword in
                vm.prePasswordObserver.accept(crtPassword)
                vm.crtPasswordObserver.accept("")   // 숫자 초기화
                vm.crtPasswordObserver.accept(nil)
                output.descriptionLabelType.accept(.onemoreNewPasswordInput)
            }.disposed(by: disposeBag)
        
        input.numberPadCellTapObserver
            .filter { $0 == .confirm }
            .withLatestFrom(viewType)
            .filter { $0 == .newSettings }
            .withLatestFrom(output.descriptionLabelType)
            .filter { $0 == .onemoreInitPasswordInput }
            .withLatestFrom(crtPasswordObserver)
            .compactMap { $0 }
            .filter { $0.count == 4 }
            .withUnretained(self)
            .bind { vm, crtPW in
                if vm.prePasswordObserver.value == crtPW {
                    vm.prePasswordObserver.accept(nil)
                    vm.crtPasswordObserver.accept("")
                    vm.crtPasswordObserver.accept(nil)
                    vm.coordinator?.showLockNumberHintFlow(type: .settings, with: crtPW)
                } else {
                    vm.prePasswordObserver.accept(nil)
                    vm.crtPasswordObserver.accept("")
                    vm.crtPasswordObserver.accept(nil)
                    output.descriptionLabelType.accept(.differentPassword)
                }
            }.disposed(by: disposeBag)
        
        input.numberPadCellTapObserver
            .filter { $0 == .confirm }
            .withLatestFrom(viewType)
            .filter { $0 == .changePassword }
            .withLatestFrom(output.descriptionLabelType)
            .filter { $0 == .onemoreNewPasswordInput }
            .withLatestFrom(crtPasswordObserver)
            .compactMap { $0 }
            .filter { $0.count == 4 }
            .withUnretained(self)
            .bind { vm, crtPW in
                if vm.prePasswordObserver.value == crtPW { // 암호 변경
                    vm.configurationUseCase
                        .resetLockNumber(crtPW)
                        .filter { $0 }
                        .bind { _ in
                            vm.coordinator?.finish()
                            vm.prePasswordObserver.accept(nil)
                            vm.crtPasswordObserver.accept("")
                            vm.crtPasswordObserver.accept(nil)
                            LockScreenSettingsViewModel.toastMessagePopObserver.accept(.reset)
                        }.disposed(by: vm.disposeBag)
                } else { // 변경 암호 불일치
                    vm.prePasswordObserver.accept(nil)
                    vm.crtPasswordObserver.accept("")
                    vm.crtPasswordObserver.accept(nil)
                    output.descriptionLabelType.accept(.differentPassword)
                }
            }.disposed(by: disposeBag)
        
        input.hintButtonTapOberver
            .withUnretained(self)
            .bind { vm, _ in
                vm.crtPasswordObserver.accept("")
                vm.crtPasswordObserver.accept(nil)
                vm.coordinator?.showLockNumberHintFlow(type: .reset, with: nil)
            }.disposed(by: disposeBag)
        
        /*
          - Access 모드에서는 확인버튼 터치 없이 비밀번호 4자리 입력 후 바로 화면 이동
          - 마지막 버튼이 눌린 후 화면에 표시되는 시간을 고려한 지연
         */
        crtPasswordObserver
            .compactMap { $0 }
            .filter { $0.count == 4 }
            .withLatestFrom(viewType) { (password: $0, type: $1) }
            .filter { event in event.type == .access }
            .map { event -> String in event.password }
            .withLatestFrom(setPasswordObserver) { (enteredPassword: $0, setPassword: $1) }
            .delay(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { vm, event in
                if event.enteredPassword == event.setPassword {
                    vm.coordinator?.finish()
                } else {
                    vm.crtPasswordObserver.accept("")
                    vm.crtPasswordObserver.accept(nil)
                    output.descriptionLabelType.accept(.missMatchPassword)
                }
            }.disposed(by: disposeBag)
        
        crtPasswordObserver
            .compactMap { $0 }
            .map { $0.count }
            .bind(to: output.passwordCount)
            .disposed(by: disposeBag)
        
        
        return output
    }
}

extension LockNumberPadViewModel {
    private func convertToLockNumberPadViewDescriptionType(by type: LockNumberPadViewType) -> LockNumberPadViewDescriptionType? {
        switch type {
        case .access:
            return nil
        case .newSettings:
            return .initPasswordInput
        case .changePassword:
            return .newPasswordInput
        }
    }
}
