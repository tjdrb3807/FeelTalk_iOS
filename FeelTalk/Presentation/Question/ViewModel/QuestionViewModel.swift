//
//  QuestionViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/30.
//

import Foundation
import RxSwift
import RxCocoa

final class QuestionViewModel {
    private weak var coordinator: QuestionCoordinator?
    private let questionUseCase: QuestionUseCase
    private let disposeBag = DisposeBag()
    
    private let currentQuestionPage = PublishSubject<QuestionPage>()
    private let todayQuestion = PublishRelay<Question>()
    private let questionList = BehaviorRelay<[Question]>(value: [])
    private var isFirstQuestionLoading = true
    
    private let lock = NSLock()
    private func synchronize(action: () -> Void) {
        if lock.lock(before: Date().addingTimeInterval(10)) {
            action()
            lock.unlock()
        } else {
            print("Took to long to lock, avoiding deadlock by ignoring the lock")
            action()
        }
    }
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapQuestionAnswerButton: Observable<Question>
        let questionSelected: Observable<Question>
        let isPagination: Observable<Bool>
        let tapChatRoomButton: ControlEvent<Void>
    }
    
    struct Output {
        let todayQuestion: PublishRelay<Question>
        let questionList: BehaviorRelay<[Question]>
    }
    
    init(coordiantor: QuestionCoordinator, questionUseCase: QuestionUseCase) {
        self.coordinator = coordiantor
        self.questionUseCase = questionUseCase
    }
    
    func reloadTodayQuestion() {
        self.questionUseCase.getTodayQuestion()
            .asObservable()
            .bind(to: self.todayQuestion)
            .disposed(by: self.disposeBag)
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .element(at: 0)
            .withUnretained(self)
            .bind { vm, _ in
                vm.questionUseCase.getLatestQuestionPageNo()
                    .bind(to: vm.currentQuestionPage)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                vm.questionUseCase.getTodayQuestion()
                    .asObservable()
                    .bind(to: vm.todayQuestion)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        currentQuestionPage
            .withUnretained(self)
            .bind { vm, pageNo in
                vm.questionUseCase
                    .getQuestionList(questionPage: pageNo)
                    .withLatestFrom(vm.questionList) {
                        (newFetchQuestionList: $0, currentQuestionList: $1)
                    }
                    .bind(onNext: { data in
                        var newList = data.newFetchQuestionList
                        if vm.isFirstQuestionLoading && data.currentQuestionList.isEmpty {
                            vm.isFirstQuestionLoading = false
                            let removed = newList.remove(at: 0)
                        }
                        var questionList: [Question] = data.currentQuestionList
                        questionList.append(contentsOf: newList)
                        let sorted = questionList.sorted(by: { first, second in
                            first.index > second.index
                        })
                        vm.questionList.accept(sorted)
                    })
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        questionList
            .filter { $0.count <= 5 }
            .withLatestFrom(currentQuestionPage) { (list: $0, page: $1) }
            .filter { $0.page.pageNo > 0 }
            .element(at: 0)
            .withUnretained(self)
            .bind { vm, data in
                let nextQuestionPage = QuestionPage(pageNo: data.page.pageNo - 1)
                vm.currentQuestionPage.onNext(nextQuestionPage)
            }.disposed(by: disposeBag)
        
        input.isPagination
            .filter { _ in true }
            .withLatestFrom(currentQuestionPage)
            .filter { $0.pageNo > 0 }
            .map { QuestionPage(pageNo: $0.pageNo - 1) }
            .bind(to: currentQuestionPage)
            .disposed(by: disposeBag)

        Observable
            .merge(input.tapQuestionAnswerButton,
                   input.questionSelected)
            .withUnretained(self)
            .bind { vm, quesiton in
                vm.coordinator?.showAnswerFlow()
                vm.coordinator?.model.accept(quesiton)
            }.disposed(by: disposeBag)
    
        input.tapChatRoomButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showChatFlow()
            }.disposed(by: disposeBag)
        
        return Output(todayQuestion: self.todayQuestion,
                      questionList: self.questionList)
    }
}

