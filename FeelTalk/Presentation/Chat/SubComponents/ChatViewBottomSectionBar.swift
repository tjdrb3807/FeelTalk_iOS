//
//  ChatViewBottomSectionBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/25.
//

import RxSwift
import RxCocoa

final class ChatViewBottomSectionBar: BaseView {
    enum TextViewInnerButtonType {
        case voiceRecode
        case messageSendPossible
        case messageSendImpossible
    }
    
    private let viewModel = ChatViewModel()
    private let disposeBag = DisposeBag()
    private let textViewInnerButtonTypeObserver = BehaviorRelay<TextViewInnerButtonType>(value: .voiceRecode)
    
    private lazy var fullHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_plus"), for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "pretendard-regular", size: 16.0)
        textView.textColor = .black
        textView.backgroundColor = UIColor(named: "gray_100")
        textView.textInputView.backgroundColor = .clear
        textView.contentInset = .init(top: 9,
                                      left: 12,
                                      bottom: 9,
                                      right: (UIScreen.main.bounds.width / 100) * 12.8)
        
        textView.layer.borderColor = UIColor(named: "gray_300")?.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 16.0
        
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = true
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    lazy var textViewInnerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_voice_recode"), for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    override func setAttribute() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 0.5
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0.0,
                                                     y: 0.0,
                                                     width: UIScreen.main.bounds.width,
                                                     height: 1.0)).cgPath
    }
    
    override func setConfig() {
        
        [menuButton, inputTextView].forEach{ fullHorizontalStackView.addArrangedSubview($0) }
        
        menuButton.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 5.911) }
        
        inputTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 84.0)
        }
        
        [fullHorizontalStackView, textViewInnerButton].forEach { addSubview($0) }
        
        fullHorizontalStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 3.2)
            $0.bottom.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 1.10)
        }
        
        textViewInnerButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(fullHorizontalStackView)
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 12.8)
            $0.height.equalTo(textViewInnerButton.snp.width)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatViewBottomSectionBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewBottomSectionBar_Presentable()
    }
    
    struct ChatViewBottomSectionBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatViewBottomSectionBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
