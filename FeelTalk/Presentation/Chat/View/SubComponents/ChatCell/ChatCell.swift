//
//  ChatCell.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatCell: UICollectionViewCell {
    let modelObserver = PublishRelay<Chat>()
    private let disposeBag = DisposeBag()
    
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        
        modelObserver
            .map { model -> Bool in model.isMine }
            .bind { isMine in
                if isMine {
                    stackView.alignment = .trailing
                    stackView.snp.makeConstraints {
                        $0.top.equalToSuperview()
                        $0.trailing.equalToSuperview().inset(20.0)
                    }
                } else {
                    stackView.alignment = .leading
                    stackView.snp.makeConstraints {
                        $0.top.equalToSuperview()
                        $0.leading.equalToSuperview().inset(20.0)
                    }
                }
            }.disposed(by: disposeBag)
        
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .bottom
        stackView.distribution = .fillProportionally
        stackView.spacing = 8.0
        
        modelObserver
            .bind { model in
                switch model.type {
                case .addChallengeChatting:
                    let stateView = ChatStateView()
                    stateView.modelObserver.accept(ChatCellState(isRead: model.isRead, isMine: model.isMine, createAt: model.createAt))
                    
                    let challengeOpenGraph = ChallengeOpenGraph()
                    challengeOpenGraph.snp.makeConstraints {
                        $0.width.equalTo(250.0)
                        $0.height.equalTo(308.0)
                    }
                    challengeOpenGraph.modelObserver.accept(model as! ChallengeChat)
                    
                    if model.isMine {
                        [stateView, challengeOpenGraph].forEach { stackView.addArrangedSubview($0) }
                    } else {
                        [challengeOpenGraph, stateView].forEach { stackView.addArrangedSubview($0) }
                    }
                case .answerChatting:
                    break
                case .textChatting:
                    let stateView = ChatStateView()
                    stateView.modelObserver.accept(ChatCellState(isRead: model.isRead, isMine: model.isMine, createAt: model.createAt))
                    
                    let textView = TextChatView(isMine: model.isMine, message: (model as! TextChat).text)
//                    textView.snp.makeConstraints {
//                        $0.width.equalTo(250.0)
//                        $0.height.equalTo(308.0)
//                    }
                    
                    if model.isMine {
                        [stateView, textView].forEach { stackView.addArrangedSubview($0) }
                    } else {
                        [textView, stateView].forEach { stackView.addArrangedSubview($0) }
                    }
                case .voiceChatting:
                    break
                case .imageChatting:
                    break
                case .questionChatting:
                    break
                case .challengeChatting:
                    break
                case .emojiChatting:
                    break
                case .resetPartnerPasswordChatting:
                    break
                case .pressForAnswerChatting:
                    break
                case .completeChallengeChatting:
                    break
                case .signalChatting:
                    break
                }
            }.disposed(by: disposeBag)
        
        return stackView
    }()
    
    private lazy var stateView: ChatStateView = {
        let view = ChatStateView()
        
        modelObserver
            .withUnretained(self)
            .bind { vm, model in
                view.modelObserver
                    .accept(ChatCellState(
                        isRead: model.isRead,
                        isMine: model.isMine,
                        createAt: model.createAt))
                model.isMine ?
                vm.contentStackView.insertArrangedSubview(view, at: 0) :
                vm.contentStackView.insertArrangedSubview(view, at: 1)
            }.disposed(by: disposeBag)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addTotalStackViewSubComponents()
    }
    
    private func setConstraints() {
        
    }
}

extension ChatCell {
    private func addViewSubComponents() { contentView.addSubview(totalStackView) }
    
    private func addTotalStackViewSubComponents() { totalStackView.addArrangedSubview(contentStackView) }
}

extension ChatCell {
    func setPartnerProfile() {
        let partnerInfoView = ChatPartnerInfoView()
        partnerInfoView.snp.makeConstraints { $0.height.equalTo(28.0) }
        totalStackView.insertArrangedSubview(partnerInfoView, at: 0)
    }
}

#if DEBUG

import SwiftUI

struct ChatCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatCell_Presentable()
    }
    
    struct ChatCell_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let c = ChatCell()
            c.modelObserver.accept(ChallengeChat(index: 0, type: .addChallengeChatting, isRead: false, isMine: false, createAt: "2024-01-01T12:00:00", challengeIndex: 0, challengeTitle: "다섯글자임다섯글자임다섯글자임다섯글자임", challengeDeadline: "2025-01-01T12:00:00"))
            
//            c.setPartnerProfile()
            
            return c
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
