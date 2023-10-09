//
//  InquiryViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

final class InquiryViewModel {
    private weak var coodinator: InquiryCoordinator?
    private let disposeBag = DisposeBag()
    
    private let keyboardHeight = BehaviorRelay<CGFloat>(value: 0.0)
    private let isDataSubmitEnabled = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let titleText: ControlProperty<String>
        let contentText: ControlProperty<String>
        let emailText: ControlProperty<String>
        let tapSubmitButton: ControlEvent<Void>
        let tapDismissButton: ControlEvent<Void>
    }
    
    struct Output {
        let keyboardHeight: BehaviorRelay<CGFloat>
        let isDataSubmitEnabled: BehaviorRelay<Bool>
    }
    
    init(coordinator: InquiryCoordinator) {
        self.coodinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .withUnretained(self)
            .bind { vm, keyboardHeight in
                vm.keyboardHeight.accept(keyboardHeight)
            }.disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                input.titleText.map { $0.count > 0 ? true : false },
                input.contentText.filter { $0 != "페이지 에러, 건의사항, 필로우톡에게 궁금한 점 등 자유롭게 문의 내용을 작성해 주세요 !" }
                    .map { $0.count > 0 ? true : false },
                input.emailText.map { $0.count > 0 ? true : false }
            ) { $0 && $1 && $2 }
            .bind(to: isDataSubmitEnabled)
            .disposed(by: disposeBag)
        
        input.tapSubmitButton
            .withUnretained(self)
            .bind { vm, _ in
                print("tap submitButton")
            }.disposed(by: disposeBag)
        
        return Output(keyboardHeight: self.keyboardHeight,
                      isDataSubmitEnabled: self.isDataSubmitEnabled)
    }
}
