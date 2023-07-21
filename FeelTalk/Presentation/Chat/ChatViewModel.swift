//
//  ChatViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/27.
//

import RxSwift
import RxCocoa
import RxKeyboard

enum ChatViewState {
    case activeSendChat
    case activeSendVoiceRecode
    case activeVoiceRecode
    case inActiveVoiceRecode
    case pauseVoiceRecode
}

final class ChatViewModel: ViewModelType {
    struct Input {
        let additionalFunctionButtonTapObserver: ControlEvent<Void>
        let inputTextViewBeginEdtingObserver: ControlEvent<Void>
        let inputTextViewEndEditingObserver: ControlEvent<Void>
        let inputTextViewTextObserver: ControlProperty<String>
        let transferButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let additionalFunctionViewHeight: Driver<CGFloat>
        let keyboardHeightObservable: BehaviorRelay<CGFloat>
    }
    
    var disposeBag = DisposeBag()

    let additionalFunctionViewHeight = BehaviorRelay<CGFloat>(value: 0.0)
    private let chatViewStateObserver = BehaviorRelay<ChatViewState>(value: .inActiveVoiceRecode)
    private let keyboardHeight = BehaviorRelay<CGFloat>(value: 0.0)
    

    func transform(input: Input) -> Output {
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .bind { [weak self] in
                guard let self = self else { return }
                keyboardHeight.accept($0)
            }.disposed(by: disposeBag)
            
        /// additionalFunctionView 높이 설정
        input.additionalFunctionButtonTapObserver
            .asObservable()
            .scan(false) { lastState, newState in !lastState }
            .withLatestFrom(keyboardHeight) {
                if $0 {
                    return $1 == 0.0 ? 335.0 : $1
                } else {
                    return 0.0
                }
            }.bind(to: additionalFunctionViewHeight)
            .disposed(by: disposeBag)
        
        input.transferButtonTapObserver
            .withLatestFrom(self.chatViewStateObserver)
            .map { type in
                switch type {
                case .activeSendChat:
                    return ChatViewState.inActiveVoiceRecode
                case .activeSendVoiceRecode:
                    return ChatViewState.activeVoiceRecode
                case .activeVoiceRecode:
                    return ChatViewState.pauseVoiceRecode
                case .inActiveVoiceRecode:
                    return ChatViewState.activeVoiceRecode
                case .pauseVoiceRecode:
                    return ChatViewState.activeSendVoiceRecode
                }
            }.bind(to: self.chatViewStateObserver)
            .disposed(by: disposeBag)
        
        return Output(additionalFunctionViewHeight: additionalFunctionViewHeight.asDriver(),
                      keyboardHeightObservable: keyboardHeight)
    }
}
