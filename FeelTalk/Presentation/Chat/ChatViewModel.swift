//
//  ChatViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/27.
//

import RxSwift
import RxCocoa

enum ChatViewState {
    case activeSendChat
    case activeSendVoiceRecode
    case activeVoiceRecode
    case inActiveVoiceRecode
    case pauseVoiceRecode
}

final class ChatViewModel: ViewModelType {
    struct Input {
        let bottomBarMenuButtonTapObserver: ControlEvent<Void>
        let inputTextViewBegineEditingObserver: ControlEvent<Void>
        let inputTextViewEndEditingObserver: ControlEvent<Void>
        let inputTextViewTextObserver: ControlProperty<String>
        let transferButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let chatViewState: PublishRelay<ChatViewState>
    }
    
    var disposeBag = DisposeBag()
    
    private let chatViewStateObserver = BehaviorRelay<ChatViewState>(value: .inActiveVoiceRecode)
    
    // Bind Output
    private let chatViewState = PublishRelay<ChatViewState>()
    
    func transform(input: Input) -> Output {
        chatViewStateObserver
            .bind(to: self.chatViewState)
            .disposed(by: disposeBag)
        
        input.transferButtonTapObserver
            .withLatestFrom(self.chatViewStateObserver) { $1 }
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
        
        input.inputTextViewBegineEditingObserver
            .withLatestFrom(input.inputTextViewTextObserver) {
                $1.count > 0 ? ChatViewState.activeSendChat : ChatViewState.inActiveVoiceRecode
            }.bind(to: chatViewStateObserver)
            .disposed(by: disposeBag)
        
        input.inputTextViewEndEditingObserver
            .withLatestFrom(input.inputTextViewTextObserver) {
                $1.count > 0 ? ChatViewState.activeSendChat : ChatViewState.inActiveVoiceRecode
            }.bind(to: chatViewStateObserver)
            .disposed(by: disposeBag)

        
        input.inputTextViewTextObserver
            .skip(1)
            .withLatestFrom(self.chatViewStateObserver) {
                if $1 == .activeVoiceRecode {
                    return ChatViewState.activeVoiceRecode
                } else {
                    return $0.count > 0 ? ChatViewState.activeSendChat : ChatViewState.inActiveVoiceRecode
                }
            }.bind(to: chatViewStateObserver)
            .disposed(by: disposeBag)
        
//        input.tapBottomBarTextViewInnerButton
//            .withLatestFrom(self.textViewInnerButtonTypeObservable) { $1 }
//            .filter { $0 == .messageSendPossible }
//            .withLatestFrom(input.bottomBarInputTextViewTextObserver) { $1 }
//            .distinctUntilChanged()
//            .flatMapLatest(ChatModel.shared.sendTextChat)
//            .share()
        
        return Output(chatViewState: self.chatViewState)
    }
}


//        inputTextView.rx.didChange
//            .bind(onNext: { [weak self] in
//                guard let self = self else { return }
//                let size = CGSize(width: self.inputTextView.frame.width, height: self.inputTextView.frame.height)
//                let estimatedSize = self.inputTextView.sizeThatFits(size)
//                let isMaxHeight = estimatedSize.height >= 70.0 // 3줄 높이
//                let state = isMaxHeight != self.inputTextView.isScrollEnabled ? true :  false
//
//                self.inputTextView.isScrollEnabled = state
//                self.inputTextView.reloadInputViews()
//                self.setNeedsUpdateConstraints()
//
//            }).disposed(by: disposeBag)

