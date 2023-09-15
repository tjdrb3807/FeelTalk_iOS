//
//  QuestionUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/26.
//

import Foundation
import RxSwift
import RxCocoa

protocol QuestionUseCase {
    func getLatestQuestionPageNo() -> Observable<QuestionPage>
    func getTodayQuestion() -> Single<Question>
    func getQuestionList(questionPage: QuestionPage) -> Observable<[Question]>
    func getQuestion(index: Int) -> Observable<Question>
    func answerQuestion(answer: QuestionAnswer) -> Observable<Bool>
//    func preseForAnswer(index: Int) -> Observable<Bool>
}

final class DefaultQuestionUseCase: QuestionUseCase {
    private let questionRepository: QuestionRepository
    private let disposbag = DisposeBag()
    
    init(questionRepository: QuestionRepository) {
        self.questionRepository = questionRepository
    }
    
    func getQuestionList(questionPage: QuestionPage) -> Observable<[Question]> {
        print("CALL getQuestList")
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            guard let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            questionRepository.getQuestionList(accessToken: accessToken, questionPage: questionPage)
                .asObservable()
                .bind(onNext: { questions in
                    observer.onNext(questions)
                }).disposed(by: disposbag)
            
            return Disposables.create()
        }
    }
    
    func getQuestion(index: Int) -> Observable<Question> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create()}
            guard let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            questionRepository.getQuestion(accessToken: accessToken, index: index)
                .asObservable()
                .bind(onNext: { question in
                    observer.onNext(question)
                }).disposed(by: disposbag)
            
            return Disposables.create()
        }
    }
    
    func getLatestQuestionPageNo() -> Observable<QuestionPage> {
        print("[CALL]: QuestionUseCase - getLatestQuestionPageNo() ")
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            
            questionRepository.getLatestQuestionPageNo(accessToken: accessToken)
                .subscribe(
                    onSuccess: { questionPage in
                        observer.onNext(questionPage)
                    },
                    onFailure: { error in
                        print(error.localizedDescription)
                    },
                    onDisposed: nil)
                .disposed(by: disposbag)
            
            return Disposables.create()
        }
    }
    
    func getTodayQuestion() -> Single<Question> {
        return Single.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create()}
            guard let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            questionRepository.getTodayQuestion(accessToken: accessToken)
                .subscribe(
                    onSuccess: { observer(.success($0)) },
                    onFailure: { observer(.failure($0)) },
                    onDisposed: nil)
                .disposed(by: disposbag)
            
            return Disposables.create()
        }
    }
    
    func answerQuestion(answer: QuestionAnswer) -> Observable<Bool> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String else { return Disposables.create() }
            questionRepository.answerQuestion(accessToken: accessToken, answer: answer)
                .subscribe(
                    onSuccess: { state in
                        observer.onNext(state)
                    },
                    onFailure: { error in
                        print(error.localizedDescription)
                    },
                    onDisposed: nil)
                .disposed(by: disposbag)
            
            return Disposables.create()
        }
    }
    
    
        
}
