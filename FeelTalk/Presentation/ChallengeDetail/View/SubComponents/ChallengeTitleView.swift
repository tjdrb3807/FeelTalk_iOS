//
//  ChallengeTitleView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeTitleView: UIStackView {
    let typeObserver = PublishRelay<ChallengeDetailViewType>()
    let toolBarButtonTapObserver = PublishRelay<ChallengeDetailViewInputType>()
    private let disposeBag = DisposeBag()
    
    private lazy var leadingSpacing: UIView = { UIView() }()
    
    private lazy var trailingSpacing: UIView = { UIView() }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeTitleInputViewNameSpace.contentStackViewSpacing
        
        return stackView
    }()

    private lazy var inputViewTitle: CustomInputViewTitle = { CustomInputViewTitle(type: .challengeTitle, isRequiredInput: false) }()
    
    lazy var titleInputView: CustomTextField01 = {
        let inputView = CustomTextField01(placeholder: ChallengeTitleInputViewNameSpace.titleInputViewPlaceholder,
                                          useClearButton: true,
                                          textLimit: ChallengeTitleInputViewNameSpace.titleInputViewTextLimit)
        
        return inputView
    }()

    lazy var toolbar: ChallengeDetailToolbar = { ChallengeDetailToolbar(type: .title) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {
        typeObserver
            .withUnretained(self)
            .bind { v, type in
                v.setTitleInputviewProperties(with: type)
            }.disposed(by: disposeBag)
        
        typeObserver
            .filter { $0 == .new || $0 == .modify }
            .withUnretained(self)
            .bind { v, _ in
                v.setUpToolBar()
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes(){
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = ChallengeTitleInputViewNameSpace.spacing
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addContentStackViewSubComponents()
    }
    
    private func setConfigurations() {
        makeInputViewTitleConstraints()
        makeTitleInputViewConstraints()
    }
}

extension ChallengeTitleView {
    private func addViewSubComponents() {
        [leadingSpacing, contentStackView, trailingSpacing].forEach { addArrangedSubview($0) }
    }
    
    private func addContentStackViewSubComponents() {
        [inputViewTitle, titleInputView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func makeInputViewTitleConstraints() {
        inputViewTitle.snp.makeConstraints {
            $0.height.equalTo(ChallengeTitleInputViewNameSpace.inputViewHeight)
        }
    }
    
    private func makeTitleInputViewConstraints() {
        titleInputView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(ChallengeTitleInputViewNameSpace.titleInputViewHeight)
        }
    }
}

extension ChallengeTitleView {
    private func setTitleInputviewProperties(with type: ChallengeDetailViewType) {
        switch type {
        case .completed, .ongoing:
            titleInputView.rx.isEnabled.onNext(false)
        case .modify, .new:
            titleInputView.rx.isEnabled.onNext(true)
        }
    }
    
    private func setUpToolBar() {
        let toolBar = ChallengeDetailToolbar(type: .title)
        
        toolBar.nextButton.rx.tap
            .map { ChallengeDetailViewInputType.title }
            .bind(to: toolBarButtonTapObserver)
            .disposed(by: disposeBag)
        
        titleInputView.inputAccessoryView = toolBar
    }
}

#if DEBUG

import SwiftUI

struct ChallengeTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeTitleView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width,
                   height: ChallengeTitleInputViewNameSpace.height,
                   alignment: .center)
    }
    
    struct ChallengeTitleView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = ChallengeTitleView()
            v.typeObserver.accept(.new)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
