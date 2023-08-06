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
    
    private let latestQuestionPage = PublishSubject<QuestionPage>()
    private let currnetQuestionPage = PublishSubject<QuestionPage>()
    private let todayQuestion = PublishRelay<Question>()
    private let questionList = BehaviorRelay<[Question]>(value: [])
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapQuestionAnswerButton: Observable<Question>
        let questionSelected: Observable<Question>
        let prefetchRow: Observable<Int>
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
        // 서버에 등록된 가장 마지막(최신 없데이트 된) 페이지 번호 가져오기
        input.viewWillAppear
            .element(at: 0)
            .withUnretained(self)
            .bind { vm, _ in
                vm.questionUseCase.getLatestQuestionPageNo()
                    .bind(to: vm.latestQuestionPage)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        // 오늘의 질문 가져오기(00:00 마다 서버에서 오늘의 질문 추가됨)
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                vm.questionUseCase.getTodayQuestion()
                    .asObservable()
                    .bind(to: vm.todayQuestion)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)

        Observable
            .merge(latestQuestionPage,
                   currnetQuestionPage
                .skip(1)) // line 86 무시
            .withUnretained(self)
            .bind { vm, questionPage in
                vm.questionUseCase.getQuestionList(questionPage: questionPage)
                    .withLatestFrom(vm.questionList) { newFetchQuestionList, currentQuestionList -> [Question] in
                        var questionList: [Question] = currentQuestionList
                        questionList.append(contentsOf: newFetchQuestionList)
                        
                        return questionList
                    }
                    .bind(to: vm.questionList)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        // 처음 가져온 QuestionList의 data 수가 부족할 경우 호출되는 Observable
        questionList
            .element(at: 1)
            .filter { questionList in questionList.count < 6 }
            .withLatestFrom(latestQuestionPage)
            .filter { questionPage in questionPage.pageNo > 0 }
            .withUnretained(self)
            .bind { vm, currentPage in
                let nextQuestionPage = QuestionPage(pageNo: currentPage.pageNo - 1)
                vm.currnetQuestionPage.onNext(nextQuestionPage)
                vm.questionUseCase.getQuestionList(questionPage: nextQuestionPage)
                    .withLatestFrom(vm.questionList) { newFetchQuestionList, currentQuestionList -> [Question] in
                        var questionList: [Question] = currentQuestionList
                        questionList.append(contentsOf: newFetchQuestionList)

                        return questionList
                    }.bind { questionList in
                        vm.questionList.accept(questionList)
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.isPagination
            .withLatestFrom(currnetQuestionPage)
            .filter { $0.pageNo - 1 > -1 }
            .map { QuestionPage(pageNo: $0.pageNo - 1) }
            .bind(to: currnetQuestionPage)
            .disposed(by: disposeBag)
            
        Observable
            .merge(input.tapQuestionAnswerButton, input.questionSelected)
            .withUnretained(self)
            .bind { vm, quesiton in
                vm.coordinator?.showAnswerFlow(with: quesiton)
            }.disposed(by: disposeBag)
    
        return Output(todayQuestion: self.todayQuestion,
                      questionList: self.questionList)
    }
}

