//
//  ChallengeDetailContentInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeDetailContentInputView: UIStackView {
    let viewMode = PublishRelay<ChallengeDetailViewType>()
    let isPlaceholder = BehaviorRelay<Bool>(value: true)
    let maxContentText = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: SubComponent
    private lazy var leftSpacingView: UIView = { UIView() }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeDetailContentInputViewNameSpace.verticalStackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ChallengeDetailContentInputViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: ChallengeDetailContentInputViewNameSpace.desctiptionLabelTextColor)
        label.font = UIFont(name: ChallengeDetailContentInputViewNameSpace.descriptionLabelTextFont,
                            size: ChallengeDetailContentInputViewNameSpace.descriptionLabelTextSize)
        label.setLineHeight(height: ChallengeDetailContentInputViewNameSpace.descriptionLabelLineHeight)
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: ChallengeDetailContentInputViewNameSpace.textViewTextFont,
                               size: ChallengeDetailContentInputViewNameSpace.textViewTextSize)
        textView.backgroundColor = UIColor(named: ChallengeDetailContentInputViewNameSpace.textViewDefaultBackgroundColor)
        textView.layer.cornerRadius = ChallengeDetailContentInputViewNameSpace.textViewCornerRadius
        textView.layer.borderWidth = ChallengeDetailContentInputViewNameSpace.textViewBorderWidth
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.tintColor = UIColor(named: ChallengeDetailContentInputViewNameSpace.textViewTintColor)
        textView.clipsToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: ChallengeDetailContentInputViewNameSpace.textViewTextContainerTopInset,
                                                   left: ChallengeDetailContentInputViewNameSpace.textViewTextContainerLeftInset,
                                                   bottom: ChallengeDetailContentInputViewNameSpace.textViewTextContainerBottomInset,
                                                   right: ChallengeDetailContentInputViewNameSpace.textViewTextContainerRightInset)
        textView.isScrollEnabled = true
        textView.inputAccessoryView = toolbar
        
        
        return textView
    }()
    
    lazy var contentTextCountingView: TextCountingView = { TextCountingView(denominator: ChallengeDetailContentInputViewNameSpace.countingViewDenominator) }()
    
    private lazy var rightSpacingView: UIView = { UIView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    lazy var toolbar: ChallengeDetailToolbar = { ChallengeDetailToolbar(type: .content) }()
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        /// ViewMode에 따른 contentTextView 활성화
        viewMode
            .withUnretained(self)
            .bind { v, mode in
                v.isContentTextViewSelectable(with: mode)
            }.disposed(by: disposeBag)
        
        /// contentTextView 배경 및 테두리 색상 설정
        Observable
            .merge(contentTextView.rx.didBeginEditing.map { true },
                   contentTextView.rx.didEndEditing.map { false })
            .withUnretained(self)
            .bind { v, state in
                v.contentTextView.updateBackgroundColor(isEditingBegin: state)
                v.contentTextView.updateBorderColor(isEditingBegin: state)
            }.disposed(by: disposeBag)
        
        /// contentTextView placeholder 활성화 설정
        isPlaceholder
            .withUnretained(self)
            .bind { v, state in
                v.updatePlaceholder(state)
            }.disposed(by: disposeBag)
        
        /// contentTextView 글자 수 제한
        maxContentText
            .withUnretained(self)
            .bind { v, text in
                v.contentTextView.rx.text.onNext(text)
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = ChallengeDetailContentInputViewNameSpace.spacing
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addVerticalStackViewSubComponents()
        addTextViewSubComponents()
    }
    
    private func setConfigurations() {
        makeDescriptionLabelConstraints()
        makeTextViewConstraints()
        makeCountingViewConstraints()
    }
}

// MARK: Default UI setting method.
extension ChallengeDetailContentInputView {
    private func addViewSubComponents() {
        [leftSpacingView, verticalStackView, rightSpacingView].forEach { addArrangedSubview($0) }
    }
    
    private func addVerticalStackViewSubComponents() {
        [descriptionLabel, contentTextView].forEach { verticalStackView.addArrangedSubview($0) }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { $0.height.equalTo(descriptionLabel.intrinsicContentSize) }
    }
    
    private func makeTextViewConstraints() {
        contentTextView.snp.makeConstraints { $0.bottom.equalTo(contentTextView.snp.top).offset(ChallengeDetailContentInputViewNameSpace.textViewHeight) }
    }
    
    private func addTextViewSubComponents() {
        contentTextView.addSubview(contentTextCountingView)
    }
    
    private func makeCountingViewConstraints() {
        contentTextCountingView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ChallengeDetailContentInputViewNameSpace.countingViewTopInset)
            $0.trailing.equalTo(contentTextView.textInputView.snp.trailing).offset(ChallengeDetailContentInputViewNameSpace.countingViewTrailingOffset)
        }
    }
}

// MARK: Update UI setting method.
extension ChallengeDetailContentInputView {
    private func isContentTextViewSelectable(with type: ChallengeDetailViewType) {
        switch type {
        case .new, .modify:
            contentTextView.rx.isSelectable.onNext(true)
        case .ongoing, .completed:
            contentTextView.rx.isSelectable.onNext(false)
        }
    }
    
    private func updatePlaceholder(_ state: Bool) {
        if state {
            contentTextView.rx.text.onNext(ChallengeDetailContentInputViewNameSpace.textViewPlaceholder)
            contentTextView.rx.textColor.onNext(UIColor(named: ChallengeDetailContentInputViewNameSpace.textViewPlaceholderColor))
        } else {
            contentTextView.rx.text.onNext(nil)
            contentTextView.rx.textColor.onNext(.black)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailContentInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailContentInputView_Presentable()
    }
    
    struct ChallengeDetailContentInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeDetailContentInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
