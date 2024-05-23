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
    func answerQuestion(entity: Answer) -> Observable<Bool>
    
    func getLatestQuestionPageNo() -> Observable<QuestionPage>
    
    func getQuestion(index: Int) -> Observable<Question>
    
    func getQuestionList(questionPage: QuestionPage) -> Observable<[Question]>
    
    func getTodayQuestion() -> Single<Question>
    
    func pressForAnswer(index: Int) -> Observable<String>
}

final class DefaultQuestionUseCase: QuestionUseCase {
    private let questionRepository: QuestionRepository
    private let userRepository: UserRepository
    private let disposbag = DisposeBag()
    
    init(questionRepository: QuestionRepository, userRepository: UserRepository) {
        self.questionRepository = questionRepository
        self.userRepository = userRepository
    }
    
    func answerQuestion(entity: Answer) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.questionRepository
                .answerQuestion(requestDTO: entity.toDTO())
                .asObservable()
                .subscribe(onNext: { result in
                    observer.onNext(result)
                    if result == true {
                        // MARK: Mixpanel
                        MixpanelRepository.shared.answerQuestion()
                    }
                }).disposed(by: self.disposbag)
                
            
            return Disposables.create()
        }
    }
    
    func getLatestQuestionPageNo() -> Observable<QuestionPage> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            self.questionRepository
                .getLatestQuestionPageNo()
                .subscribe(
                    onSuccess: { questionPage in
                        observer.onNext(questionPage)
                    },
                    onFailure: { error in
                        print(error.localizedDescription)
                    },
                    onDisposed: nil)
                .disposed(by: self.disposbag)
            
            return Disposables.create()
        }
    }
    
    func getQuestion(index: Int) -> Observable<Question> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create()}
    
            self.questionRepository
                .getQuestion(index: index)
                .asObservable()
                .bind(onNext: { question in
                    observer.onNext(question)
                }).disposed(by: self.disposbag)
            
            return Disposables.create()
        }
    }
    
    func getQuestionList(questionPage: QuestionPage) -> Observable<[Question]> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.questionRepository
                .getQuestionList(questionPage: questionPage)
                .asObservable()
                .bind(onNext: { questions in
                    observer.onNext(questions)
                }).disposed(by: self.disposbag)
            
            return Disposables.create()
        }
    }
    
    func getTodayQuestion() -> Single<Question> {
        return Single.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create()}
            
            self.questionRepository
                .getTodayQuestion()
                .subscribe(
                    onSuccess: { observer(.success($0)) },
                    onFailure: { observer(.failure($0)) },
                    onDisposed: nil)
                .disposed(by: self.disposbag)
            
            return Disposables.create()
        }
    }
    
    func pressForAnswer(index: Int) -> Observable<String> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.questionRepository
                .pressForAnswer(PressForAnswerRequestDTO(index: index))
                .asObservable()
                .subscribe(onNext: { event in
                    
                    self.userRepository
                        .getPartnerInfo()
                        .asObservable()
                        .bind(onNext: {
                            observer.onNext($0.nickname)
                        }).disposed(by: self.disposbag)
                }).disposed(by: self.disposbag)
            
            return Disposables.create()
        }
    }
}
