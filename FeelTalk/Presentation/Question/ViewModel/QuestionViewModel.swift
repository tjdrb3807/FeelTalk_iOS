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
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapQuestionAnswerButton: Observable<Question>
        let questionSelected: Observable<Question>
        let isPagination: Observable<Bool>
    }
    
    struct Output {
        let todayQuestion: PublishRelay<Question>
        let questionList: BehaviorRelay<[Question]>
    }
    
    init(coordiantor: QuestionCoordinator, questionUseCase: QuestionUseCase) {
        self.coordinator = coordiantor
        self.questionUseCase = questionUseCase
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
            .bind { vm, questionPage in
                vm.questionUseCase.getQuestionList(questionPage: questionPage)
                    .withLatestFrom(vm.questionList) { newFetchQuestionList, currentQuestionList -> [Question] in
                        var questionList: [Question] = currentQuestionList
                        questionList.append(contentsOf: newFetchQuestionList)
                        if !questionList.isEmpty {
                            questionList.remove(at: 0)
                        }
                        return questionList
                    }.bind(to: vm.questionList)
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
    
        return Output(todayQuestion: self.todayQuestion,
                      questionList: self.questionList)
    }
}

