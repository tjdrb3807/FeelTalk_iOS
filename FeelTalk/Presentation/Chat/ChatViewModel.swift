//
//  ChatViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/27.
//

import RxSwift
import RxCocoa

final class ChatViewModel: ViewModelType {
    enum TextViewInnerButtonType {
        case voiceRecode
        case messageSendPossible
        case messageSendImpossibe
    }
    
    enum LifeCycleType {
        case viewWillAppear
        case viewVillDisAppear
        case background
    }
    
    struct Input {
        let viewWillAppearObserver: ControlEvent<Bool>
        let viewWillDisappearObserver: ControlEvent<Bool>
        let bottomBarInputTextViewTextObserver: ControlProperty<String>
        let bottomBarInputTextViewBegineEditingObserver: ControlEvent<Void>
        let bottomBarInputTextViewEndEditingObserver: ControlEvent<Void>
        let tapBottomBarTextViewInnerButton: ControlEvent<Void>
    }
    
    struct Output {
        let bottomBarTextViewInnerButtonStateObserver: PublishSubject<(Bool, UIImage?)>
    }
    
    var disposeBag = DisposeBag()
    
    private let textViewInnerButtonTypeObservable = BehaviorRelay<TextViewInnerButtonType>(value: .voiceRecode)
    private let bottomBarTextViewInnerButtonStateObserver = PublishSubject<(Bool, UIImage?)>()
    
    func transform(input: Input) -> Output {
        textViewInnerButtonTypeObservable
            .map { type in
                switch type {
                case .voiceRecode:
                    return (true, UIImage(named: "icon_voice_recode"))
                case .messageSendPossible:
                    return (true, UIImage(named: "icon_chat_send_possible"))
                case .messageSendImpossibe:
                    return (false, UIImage(named: "icon_chat_send_possible"))
                }
            }.bind(to: self.bottomBarTextViewInnerButtonStateObserver)
            .disposed(by: disposeBag)
        
        input.bottomBarInputTextViewBegineEditingObserver
            .withLatestFrom(input.bottomBarInputTextViewTextObserver) {
                $1.count > 0 ? TextViewInnerButtonType.messageSendPossible : TextViewInnerButtonType.messageSendImpossibe
            }.bind(to: textViewInnerButtonTypeObservable)
            .disposed(by: disposeBag)
        
        input.bottomBarInputTextViewEndEditingObserver
            .withLatestFrom(input.bottomBarInputTextViewTextObserver) {
                $1.count > 0 ? TextViewInnerButtonType.messageSendPossible : TextViewInnerButtonType.voiceRecode
            }.bind(to: textViewInnerButtonTypeObservable)
            .disposed(by: disposeBag)
        
        input.bottomBarInputTextViewTextObserver
            .skip(1)
            .map { $0.count > 0 ? TextViewInnerButtonType.messageSendPossible : TextViewInnerButtonType.messageSendImpossibe}
            .bind(to: textViewInnerButtonTypeObservable)
            .disposed(by: disposeBag)
        
//        input.tapBottomBarTextViewInnerButton
//            .withLatestFrom(self.textViewInnerButtonTypeObservable) { $1 }
//            .filter { $0 == .messageSendPossible }
//            .withLatestFrom(input.bottomBarInputTextViewTextObserver) { $1 }
//            .distinctUntilChanged()
//            .flatMapLatest(ChatModel.shared.sendTextChat)
//            .share()
            
        
        return Output(bottomBarTextViewInnerButtonStateObserver: self.bottomBarTextViewInnerButtonStateObserver)
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

