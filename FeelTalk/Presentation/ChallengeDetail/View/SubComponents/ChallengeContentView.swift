//
//  ChallengeContentView.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeContentView: UIStackView {
    let typeObserver = PublishRelay<ChallengeDetailViewType>()
    let toolBarButtonTapObserver = PublishRelay<ChallengeDetailViewToolBarType>()
    private let disposeBag = DisposeBag()
    
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeContentViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()
    
    private lazy var inputViewTitle: CustomInputViewTitle = { CustomInputViewTitle(type: .challnegeContent, isRequiredInput: false) }()
    
    lazy var contentInputView: CustomTextView = { CustomTextView(placeholder: ChallengeContentViewNameSpace.contentInputViewPlaceholder,
                                                                         maxTextCout: ChallengeContentViewNameSpace.contentInputViewMaxTextCount) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        typeObserver
            .withUnretained(self)
            .bind { v, type in
                v.setContentInputViewProperties(with: type)
            }.disposed(by: disposeBag)
        
        typeObserver
            .filter { $0 == .new || $0 == .modify }
            .withUnretained(self)
            .bind { v, _ in
                v.setUpToolBar()
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = ChallengeContentViewNameSpace.spacing
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponent()
    }
    
    private func setConstraints() {
        makeInputViewTitleConstraints()
        makeContentInputViewConstraints()
    }
}

extension ChallengeContentView {
    private func addViewSubComponents() {
        [leadingSpacing, contentStackView, trailingSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func addContentStackViewSubComponent() {
        [inputViewTitle, contentInputView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeInputViewTitleConstraints() {
        inputViewTitle.snp.makeConstraints {
            $0.height.equalTo(ChallengeContentViewNameSpace.inputViewTitleHeight)
        }
    }
    
    private func makeContentInputViewConstraints() {
        contentInputView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChallengeContentViewNameSpace.contentInputviewHeight)
        }
    }
}

extension ChallengeContentView {
    private func setContentInputViewProperties(with type: ChallengeDetailViewType) {
        switch type {
        case .completed, .ongoing:
            contentInputView.textView.rx.isEditable.onNext(false)
        case .modify, .new:
            contentInputView.textView.rx.isEditable.onNext(true)
        }
    }
    
    private func setUpToolBar() {
        let toolBar = CustomToolbar(type: .completion)
        
        toolBar.rightButton.rx.tap
            .map { .content }
            .bind(to: toolBarButtonTapObserver)
            .disposed(by: disposeBag)
        
        contentInputView.textView.inputAccessoryView = toolBar
    }
}

#if DEBUG

import SwiftUI

struct ChallengeContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeContentView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChallengeContentViewNameSpace.height,
                   alignment: .center)
    }
    
    struct ChallengeContentView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeContentView()
            v.typeObserver.accept(.modify)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
