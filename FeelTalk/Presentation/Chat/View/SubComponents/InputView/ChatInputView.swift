//
//  ChatInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum ChatInputMode {
    case basics
    case recordingDescription
    case recording
    case recorded
    case inputMessage
}

final class ChatInputView: UIStackView {
    let mode = PublishRelay<ChatInputMode>()
    let refresh = BehaviorRelay(value: false)
    let isFunctionActive = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
    private lazy var topSpacing: UIView = { UIView() }()
    
    private lazy var bottomSpacing: UIView = { UIView() }()
    
    private lazy var totalStackView: UIStackView = {
        let stackViwe = UIStackView()
        stackViwe.axis = .horizontal
        stackViwe.alignment = .bottom
        stackViwe.distribution = .fillProportionally
        stackViwe.backgroundColor = .clear
        
        return stackViwe
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fill
        
        stackView.layer.cornerRadius = ChatInputViewNameSapce.contentStackViewCornerRadius
        stackView.layer.borderWidth = ChatInputViewNameSapce.contentStackViewBorderWitth
        
        stackView.clipsToBounds = true
        
        return stackView
    }()
    
    lazy var functionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        
        return button
    }()
    
    lazy var messageInputView: ChatMessageInputView = { ChatMessageInputView() }()
    
    private lazy var recordingDescriptionView: ChatRecordingDescriptionView = { ChatRecordingDescriptionView() }()
    
    lazy var recordingView: ChatRecordingView = { ChatRecordingView() }()
    
    lazy var inputButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(ChatInputViewNameSapce.inputButtonImageViewVertivalInset)
            $0.leading.trailing.equalToSuperview().inset(ChatInputViewNameSapce.inputButtonImageViewHorizontalInset)
        }
        button.imageView?.contentMode = .center
        button.imageView?.layer.cornerRadius = ChatInputViewNameSapce.inputButtonImageViewCornerRadius
        button.imageView?.clipsToBounds = true
        
        return button
    }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: UIScreen.main.bounds.width,
                                              height: ChatInputViewNameSapce.height)))
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        mode
            .withLatestFrom(refresh) { (mode: $0, isRefresh: $1) }
            .withUnretained(self)
            .bind { v, data in
                v.switchInputButton(with: data.mode)
                v.switchContentStackView(with: data.mode)
                v.switchContent(with: data.mode, isRefresh: data.isRefresh)
                if data.mode == .basics { v.messageInputView.textClear.accept(()) }
            }.disposed(by: disposeBag)
        
        inputButton.rx.tap
            .withLatestFrom(mode)
            .filter { $0 == .recordingDescription }
            .withUnretained(self)
            .bind { v, _ in
                print("녹음 시작")
//                v.recordingView.isRecord.accept(true)
            }.disposed(by: disposeBag)
        
        inputButton.rx.tap
            .withLatestFrom(mode)
            .filter { $0 == .recording }
            .withUnretained(self)
            .bind { v, _ in
                print("녹음 중지")
//                v.recordingView.isRecord.accept(false)
            }.disposed(by: disposeBag)
        
        isFunctionActive
            .withUnretained(self)
            .bind { v, state in
                v.switchFunctionButton(with: state)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        backgroundColor = .red
        
        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        spacing = ChatInputViewNameSapce.spacing
        backgroundColor = .white
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: ChatInputViewNameSapce.shadowPathCornerRadius).cgPath
        layer.shadowColor = UIColor(red: ChatInputViewNameSapce.shadowRedColor,
                                    green: ChatInputViewNameSapce.shadowGreenColor,
                                    blue: ChatInputViewNameSapce.shadowBlueColor,
                                    alpha: ChatInputViewNameSapce.shadowColorAlpha).cgColor
        layer.shadowOpacity = ChatInputViewNameSapce.shadowOpacity
        layer.shadowRadius = ChatInputViewNameSapce.shadowRadius
        layer.shadowOffset = CGSize(width: ChatInputViewNameSapce.shadowOffsetWidth,
                                    height: ChatInputViewNameSapce.shadowOffsetHeight)
    }
    
    private func addSubComponents() {
        addChatInputSubComponents()
        addTotalStackViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeFunctionButtonConstraints()
        makeInputButtonConstraints()
        makeTrailingSpacingConstratins()
    }
}

extension ChatInputView {
    private func addChatInputSubComponents() {
        [topSpacing, totalStackView, bottomSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func addTotalStackViewSubComponents() {
        [functionButton, contentStackView, trailingSpacing].forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func makeFunctionButtonConstraints() {
        functionButton.snp.makeConstraints {
            $0.width.equalTo(ChatInputViewNameSapce.functionButtonWidth)
            $0.height.equalTo(ChatInputViewNameSapce.functionButtonHeight)
        }
    }
    
    private func addContentStackViewSubComponents() {
        [messageInputView, inputButton].forEach { contentStackView.addArrangedSubview($0) }
    }

    private func makeInputButtonConstraints() {
        inputButton.snp.makeConstraints {
            $0.width.equalTo(ChatInputViewNameSapce.inputButtonWidth)
            $0.height.equalTo(ChatInputViewNameSapce.inputButtonHeight)
        }
    }
    
    private func makeTrailingSpacingConstratins() {
        trailingSpacing.snp.makeConstraints {
            $0.width.equalTo(ChatInputViewNameSapce.trailingSpacingWidth)
        }
    }
}

extension ChatInputView {
    private func switchInputButton(with mode: ChatInputMode) {
        switch mode {
        case .basics:
            inputButton.rx.image().onNext(UIImage(named: ChatInputViewNameSapce.inputButtonRecodingDisableModeImage))
            inputButton.imageView?.rx.backgroundColor.onNext(UIColor.clear)
        case .recordingDescription:
            inputButton.rx.image().onNext(UIImage(named: ChatInputViewNameSapce.inputButtonRecodingAbleModeImage))
            inputButton.imageView!.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500))
        case .recording:
            inputButton.rx.image().onNext(UIImage(named: ChatInputViewNameSapce.inputButtonStopRecodingModeImage))
            inputButton.imageView!.rx.backgroundColor.onNext(.white)
        case .recorded:
            inputButton.rx.image().onNext(UIImage(named: ChatInputViewNameSapce.imputButtonSendRecodingModeImage))
            inputButton.imageView!.rx.backgroundColor.onNext(.white)
        case .inputMessage:
            inputButton.rx.image().onNext(UIImage(named: ChatInputViewNameSapce.imputButtonSendMessageModeImage))
            inputButton.imageView!.rx.backgroundColor.onNext(.clear)
        }
    }
    
    private func switchContentStackView(with mode: ChatInputMode) {
        switch mode {
        case .basics, .inputMessage:
            contentStackView.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray100))
            contentStackView.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.gray300)?.cgColor)
        case .recordingDescription:
            contentStackView.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main300))
            contentStackView.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.main400)?.cgColor)
        case .recording, .recorded:
            contentStackView.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500))
            contentStackView.layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.main500)?.cgColor)
        }
    }
    
    private func switchContent(with mode: ChatInputMode, isRefresh: Bool) {
        if mode != .inputMessage && mode != .basics || isRefresh {
            let currentSubView = contentStackView.arrangedSubviews[ChatInputViewNameSapce.contentStackViewFirstSubviewIndex]
            
            contentStackView.removeArrangedSubview(currentSubView)
            currentSubView.removeFromSuperview()
        }
        
        switch mode {
        case .basics:
            contentStackView.insertArrangedSubview(messageInputView, at: ChatInputViewNameSapce.contentStackViewFirstSubviewIndex)
            refresh.accept(false)
        case .recordingDescription:
            contentStackView.insertArrangedSubview(recordingDescriptionView, at: ChatInputViewNameSapce.contentStackViewFirstSubviewIndex)
            refresh.accept(false)
        case .recording:
            contentStackView.insertArrangedSubview(recordingView, at: ChatInputViewNameSapce.contentStackViewFirstSubviewIndex)
            refresh.accept(false)
        case .recorded:
            contentStackView.insertArrangedSubview(recordingView, at: ChatInputViewNameSapce.contentStackViewFirstSubviewIndex)
            refresh.accept(true)
        case .inputMessage:
            refresh.accept(false)
        }
    }
    
    private func switchFunctionButton(with state: Bool) {
        state ?
        functionButton.rx.image().onNext(UIImage(named: "icon_cancel")) :
        functionButton.rx.image().onNext(UIImage(named: "icon_plus"))
    }
}

#if DEBUG

import SwiftUI

struct ChatInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatInputView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChatInputViewNameSapce.height,
                   alignment: .center)
    }
    
    struct ChatInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChatInputView()
            v.mode.accept(.basics)
            v.isFunctionActive.accept(false)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
