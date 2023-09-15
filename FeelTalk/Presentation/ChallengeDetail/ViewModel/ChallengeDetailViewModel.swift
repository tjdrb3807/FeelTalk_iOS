//
//  ChallengeDetailViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

final class ChallengeDetailViewModel {
    private weak var coordiantor: ChallengeDetailCoordinator?
    private let challengeUseCase: ChallengeUseCase
    private let disposeBag = DisposeBag()
    
    let model = ReplayRelay<Challenge>.create(bufferSize: 1)
    
    private let keyboardHeight = BehaviorRelay<CGFloat>(value: 0.0)
    private let viewMode = PublishRelay<ChallengeDetailViewMode>()
    private let maxTitleText = PublishRelay<String>()
    private let titleTextCount = PublishRelay<Int>()
    private let deadline = PublishRelay<String>()
    private let dDay = PublishRelay<String>()
    private let isContentPlaceholder = PublishRelay<Bool>()
    private let contentTextCount = PublishRelay<Int>()
    private let maxContentText = PublishRelay<String>()
    private let isChallengeButtonEnable = PublishRelay<Bool>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapModifyButton: ControlEvent<Void>
        let tapRemoveButton: ControlEvent<Void>
        let titleText: ControlProperty<String>
        let datePickerValueChanged: ControlEvent<Void>
        let datePickerValue: ControlProperty<Date>
        let contentTextViewBeginEditing: ControlEvent<Void>
        let contentTextViewEndEditing: ControlEvent<Void>
        let contentText: ControlProperty<String>
        let tapChallengeButton: ControlEvent<Void>
    }
    
    struct Output {
        let keyboardHeight: BehaviorRelay<CGFloat>
        let viewMode: PublishRelay<ChallengeDetailViewMode>
        let maxTitleText: PublishRelay<String>
        let titleTextCount: PublishRelay<Int>
        let deadline: PublishRelay<String>
        let dDay: PublishRelay<String>
        let isContentPlaceholder: PublishRelay<Bool>
        let contentTextCount: PublishRelay<Int>
        let maxContentText: PublishRelay<String>
        let isChallengeButtonEnable: PublishRelay<Bool>
    }
    
    init(coordinator: ChallengeDetailCoordinator, challengeUseCase: ChallengeUseCase) {
        self.coordiantor = coordinator
        self.challengeUseCase = challengeUseCase
    }
    
    func transfer(input: Input) -> Output {
        /// 키보드 높이
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .withUnretained(self)
            .bind { vm, keyboardHeight in
                vm.keyboardHeight.accept(keyboardHeight)
            }.disposed(by: disposeBag)
        
        input.viewWillAppear
            .withLatestFrom(model)
            .withUnretained(self)
            .bind { vm, model in
                vm.viewMode.accept(vm.setViewMode(with: model))
            }.disposed(by: disposeBag)
        
        /// 수정 모드로 변환
        input.tapModifyButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.viewMode.accept(.modify)
            }.disposed(by: disposeBag)
        
        /// 챌린지 삭제
        input.tapRemoveButton
            .withUnretained(self)
            .bind { vm, _ in
//                vm.challengeUseCase.removeChallenge(index: <#T##Int#>)
            }.disposed(by: disposeBag)
        
        /// titleTextField 글자수
        input.titleText
            .map { $0.count }
            .filter { $0 <= 20 }
            .withUnretained(self)
            .bind { vm, count in
                vm.titleTextCount.accept(count)
            }.disposed(by: disposeBag)
        
        /// titleTextField 글자 수 제한
        input.titleText
            .filter { $0.count > 20 }
            .withUnretained(self)
            .bind { vm, title in
                let index = title.index(title.startIndex, offsetBy: 20)
                vm.maxTitleText.accept(String(title[..<index]))
            }.disposed(by: disposeBag)
        
        /// deadline, dDay dateFormatter
        input.datePickerValueChanged
            .withLatestFrom(input.datePickerValue)
            .withUnretained(self)
            .bind { vm, date in
                vm.deadline.accept(vm.deadlineDateFormat(date: date))
                vm.dDay.accept(vm.calculateDday(from: date))
            }.disposed(by: disposeBag)
        
        /// placeholder 활성화
        input.contentTextViewBeginEditing
            .withLatestFrom(input.contentText)
            .withUnretained(self)
            .bind { vm, text in
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    vm.isContentPlaceholder.accept(true)
                } else if text == "내용을 자세히 적어보세요 !" {
                    vm.isContentPlaceholder.accept(false)
                }
            }.disposed(by: disposeBag)
        
        /// placeholder 활성화
        input.contentTextViewEndEditing
            .withLatestFrom(input.contentText)
            .filter { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || $0 == "내용을 자세히 적어보세요 !" }
            .withUnretained(self)
            .bind { vm, _ in
                vm.isContentPlaceholder.accept(true)
                vm.contentTextCount.accept(0)
            }.disposed(by: disposeBag)
            
        /// content 글자 수
        input.contentText
            .skip { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || $0 == "내용을 자세히 적어보세요 !" }
            .map { $0.count }
            .filter { $0 <= 100 }
            .withUnretained(self)
            .bind { vm, count in
                vm.contentTextCount.accept(count)
            }.disposed(by: disposeBag)
        
        /// content 글자 수 제한
        input.contentText
            .filter { $0.count > 100 }
            .withUnretained(self)
            .bind { vm, text in
                var newText = text
                newText.removeLast()
                vm.maxContentText.accept(newText)
            }.disposed(by: disposeBag)
        
        /// newMode challengeButton 활성화
        Observable
            .combineLatest(
                input.titleText.distinctUntilChanged()
                    .map { $0 == "" ? false : true },
                input.contentText.distinctUntilChanged()
                    .map { $0 == "" || $0 == "내용을 자세히 적어보세요 !" ? false : true }) { $0 && $1 }
            .distinctUntilChanged()
            .withLatestFrom(viewMode) { (state: $0, mode: $1) }
            .filter { $0.mode == .new }
            .withUnretained(self)
            .bind { vm, data in
                print(data.state)
                vm.isChallengeButtonEnable.accept(data.state)
            }.disposed(by: disposeBag)
        
        /// 챌린지 신규 등록
        input.tapChallengeButton
            .withLatestFrom(viewMode)
            .filter { $0 == .new }
            .withLatestFrom(input.titleText)
            .withLatestFrom(input.datePickerValue) { (title: $0, deadline: $1) }
            .withLatestFrom(input.contentText) { (title: $0.title, deadline: $0.deadline, content: $1) }
            .withUnretained(self)
            .bind { vm, data in
//                var model = Challenge(index: nil,
//                                      pageNo: nil,
//                                      title: data.title,
//                                      deadline: vm.deadlineFormat(date: data.deadline),
//                                      content: data.content,
//                                      creator: "아직 설정불가",
//                                      isCompleted: false)
//                vm.challengeUseCase.addChallenge(challenge: model)
//                    .bind(onNext: { index in
//                        print(index)
//                        model.index = index
//                        vm.model.accept(model)
//                        vm.viewMode.accept(.ongoing)
//                    }).disposed(by: vm.disposeBag)
                vm.challengeUseCase.modifiyChallenge(challenge: Challenge(index: 9,
                                                                          pageNo: nil,
                                                                          title: data.title,
                                                                          deadline: vm.deadlineFormat(date: data.deadline),
                                                                          content: data.content,
                                                                          creator: "아직 설정불가",
                                                                          isCompleted: false))
                .bind(onNext: {
                    print("수정\($0)")
                }).disposed(by: vm.disposeBag)
                
            }.disposed(by: disposeBag)
        
        /// 챌린지 완료
        input.tapChallengeButton
            .withLatestFrom(viewMode)
            .filter { $0 == .ongoing }
            .withUnretained(self)
            .bind { vm, _ in
//                vm.challengeUseCase.completeChallenge(index: <#T##Int#>)
            }.disposed(by: disposeBag)
        
        /// 챌린지 수정
//        input.tapChallengeButton
//            .withLatestFrom(viewMode)
//            .filter { $0 == .modify }
//            .withUnretained(self)
//            .bind { vm, _ in
//                vm.challengeUseCase.modifiyChallenge(challenge: Challenge(index: 9,
//                                                                          pageNo: nil,
//                                                                          title: "두 번쨰 테스트01",
//                                                                          deadline: "2026-02-12",
//                                                                          content: "테스트",
//                                                                          creator: "아직 모름",
//                                                                          isCompleted: false))
//                .bind(onNext: {
//                    print("챌린지 수정: \($0)")
//                }).disposed(by: vm.disposeBag)
//            }.disposed(by: disposeBag)
                                                     
                                                     
        
        
        return Output(keyboardHeight: self.keyboardHeight,
                      viewMode: self.viewMode,
                      maxTitleText: self.maxTitleText,
                      titleTextCount: self.titleTextCount,
                      deadline: self.deadline,
                      dDay: self.dDay,
                      isContentPlaceholder: self.isContentPlaceholder,
                      contentTextCount: self.contentTextCount,
                      maxContentText: self.maxContentText,
                      isChallengeButtonEnable: self.isChallengeButtonEnable)
    }
}

extension ChallengeDetailViewModel {
    private func setViewMode(with model: Challenge) -> ChallengeDetailViewMode {
        guard let isCompleted = model.isCompleted else { return .new }
        
        if isCompleted { return .completed }
        else { return .ongoing }
    }
    
    //TODO: 이름 변경
    private func deadlineDateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일까지"
        
        return formatter.string(from: date)
    }
    
    //TODO: 이름 변경
    private func deadlineFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
    
    private func calculateDday(from date: Date) -> String {
        let interval = date.timeIntervalSince(Date()) / 86400
        
        if interval < 0 {
            return "D-Day"
        } else if interval > 999 {
            return "D+999"
        } else {
            return "D-\(Int(interval) + 1)"
        }
    }
}
