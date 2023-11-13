//
//  ChatMessageInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatMessageInputView: UIStackView {
    let textClear = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private lazy var topSpacing: UIView = { UIView() }()
    
    lazy var messageInputTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                               size: CommonConstraintNameSpace.horizontalRatioCalculaotr * 4.26)      // 16.0
        textView.backgroundColor = .clear
        textView.textContainerInset.left = 12.0
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private lazy var bottomSpacing: UIView = { UIView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        textClear
            .withUnretained(self)
            .bind { v, _ in
                v.messageInputTextView.rx.text.onNext(nil)
            }.disposed(by: disposeBag)
        
        messageInputTextView.rx.didChange
            .withUnretained(self)
            .bind { v, _ in
                let size = CGSize(width: v.messageInputTextView.frame.width, height: .infinity)
                let estimatedSize = v.messageInputTextView.sizeThatFits(size)
                let isMaxHeight = estimatedSize.height > 100.0
                
                v.messageInputTextView.rx.isScrollEnabled.onNext(isMaxHeight)
                
                if isMaxHeight {
                    v.messageInputTextView.snp.remakeConstraints { $0.height.equalTo(79.33) }
                } else {
                    v.messageInputTextView.snp.removeConstraints()
                }
                
                v.messageInputTextView.reloadInputViews()
                v.messageInputTextView.setNeedsUpdateConstraints()
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = CommonConstraintNameSpace.verticalRatioCalculator * 0.86  // 7.0
        backgroundColor = .clear
    }
    
    private func addSubComponents() { addMessageInputViewSubComponents() }
}

extension ChatMessageInputView {
    private func addMessageInputViewSubComponents() { [topSpacing, messageInputTextView, bottomSpacing].forEach { addArrangedSubview($0) } }
}

#if DEBUG

import SwiftUI

struct ChatMessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageInputView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: 50,
                   alignment: .center)

    }
    
    struct ChatMessageInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatMessageInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
