//
//  ChallengeDetailTitleInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChallengeDetailTitleInputView: UIStackView {
    let viewMode = PublishRelay<ChallengeDetailViewMode>()
    let titleTextCount = BehaviorRelay<Int>(value: 0)
    let textClearButtonState = BehaviorRelay<Bool>(value: false)

    private let disposeBag = DisposeBag()
    
    private lazy var leftSpacingView: UIView = { UIView() }()
    private lazy var rightSpacingView: UIView = { UIView() }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = ChallengeDetailTitleInputViewNameSpace.stackViewSpacing
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var descriptionLable: UILabel = {
        let label = UILabel()
        label.text = ChallengeDetailTitleInputViewNameSpace.descriptionLabelText
        label.textColor = UIColor(named: ChallengeDetailTitleInputViewNameSpace.desctiptionLabelTextColor)
        label.font = UIFont(name: ChallengeDetailTitleInputViewNameSpace.descriptionLabelTextFont,
                            size: ChallengeDetailTitleInputViewNameSpace.descriptionLabelTextSize)
        label.setLineHeight(height: ChallengeDetailTitleInputViewNameSpace.descriptionLabelLineHeight)
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: ChallengeDetailTitleInputViewNameSpace.textFieldTextFont,
                                size: ChallengeDetailTitleInputViewNameSpace.textFieldTextSize)
        textField.textColor = .black
        textField.setPlaceholder(text: ChallengeDetailTitleInputViewNameSpace.textFieldPlaceholder,
                                 color: UIColor(named: ChallengeDetailTitleInputViewNameSpace.textFieldPlaceholderColor)!)
        textField.backgroundColor = UIColor(named: ChallengeDetailTitleInputViewNameSpace.textFieldDefaultBackgroundColor)
        textField.layer.borderWidth = ChallengeDetailTitleInputViewNameSpace.textFieldBorderWidth
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = ChallengeDetailTitleInputViewNameSpace.textFieldCornerRadius
        textField.clipsToBounds = true
        textField.tintColor = UIColor(named: ChallengeDetailTitleInputViewNameSpace.textFieldTintColor)
        
        let leftPaddingView = UIView(frame: CGRect(origin: .zero,
                                                   size: CGSize(width: ChallengeDetailTitleInputViewNameSpace.textFieldLeftPaddingWidth,
                                                            height: textField.frame.height)))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        textField.rightView = textFieldRightView
        textField.rightViewMode = .always
        textField.inputAccessoryView = toolbar
        
        return textField
    }()
    
    private lazy var textFieldRightView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var firstSpacingView: UIView = { UIView() }()
    
    lazy var textCountingView: TextCountingView = { TextCountingView(denominator: ChallengeDetailTitleInputViewNameSpace.textCountingViewDenominator) }()
    
    private lazy var secondSpacingView: UIView = { UIView() }()
    
    lazy var textClearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ChallengeDetailTitleInputViewNameSpace.textClearButtonImage),
                        for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var thirdSpacingView: UIView = { UIView() }()
    
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
        viewMode
            .withUnretained(self)
            .bind { v, mode in
                v.isTiteTextFieldEnable(with: mode)
            }.disposed(by: disposeBag)
        
        Observable
            .merge(titleTextField.rx.controlEvent(.editingDidBegin).map { true },
                   titleTextField.rx.controlEvent(.editingDidEnd).map { false })
            .withUnretained(self)
            .bind { v, state in
                v.titleTextField.updateBorderColor(isEditingBegin: state)
                v.titleTextField.updateBackgourndColor(isEditingBegin: state)
                if !state {
                    v.textCountingView.molecularLabel.rx.textColor.onNext(UIColor(named: "gray_400"))
                    v.textClearButtonState.accept(state)
                }
            }.disposed(by: disposeBag)
        
        titleTextCount
            .withUnretained(self)
            .bind { v, count in
                count > 0 ? v.textClearButtonState.accept(true) : v.textClearButtonState.accept(false)
                v.textCountingView.updateMolecularLabelText(count: count)
            }.disposed(by: disposeBag)
        
        textClearButton.rx.tap
            .withUnretained(self)
            .bind { v, _ in
                v.textFieldValueInit()
                v.textClearButtonState.accept(false)
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes(){
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = ChallengeDetailTitleInputViewNameSpace.spacing
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
        addStackViewComponents()
        addTextFieldRightViewSubComponents()
    }
    
    private func setConfigurations() {
        makeDescriptionLabelConstraints()
        makeSpacingViewsConstraints()
    }
}

// Defautl setting method.
extension ChallengeDetailTitleInputView {
    private func addViewSubComponents() {
        [leftSpacingView, stackView, rightSpacingView].forEach { addArrangedSubview($0) }
    }
    
    private func addStackViewComponents() {
        [descriptionLable, titleTextField].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func addTextFieldRightViewSubComponents() {
        [firstSpacingView, textCountingView, thirdSpacingView].forEach { textFieldRightView.addArrangedSubview($0) }
    }
    
    private func makeDescriptionLabelConstraints() {
        descriptionLable.snp.makeConstraints { $0.height.equalTo(descriptionLable.intrinsicContentSize) }
    }
    
    private func makeSpacingViewsConstraints() {
        firstSpacingView.snp.makeConstraints { $0.width.equalTo(ChallengeDetailTitleInputViewNameSpace.firstSpacingViewWidth) }
        secondSpacingView.snp.makeConstraints { $0.width.equalTo(ChallengeDetailTitleInputViewNameSpace.secondSpacingViewWidth) }
        thirdSpacingView.snp.makeConstraints { $0.width.equalTo(ChallengeDetailTitleInputViewNameSpace.thridSpacingViewWidth) }
    }
}

//MARK: Update UI setting method.
extension ChallengeDetailTitleInputView {
    private func isTiteTextFieldEnable(with mode: ChallengeDetailViewMode) {
        switch mode {
        case .new, .modify:
            titleTextField.rx.isEnabled.onNext(true)
        case .ongoing, .completed:
            titleTextField.rx.isEnabled.onNext(false)
        }
    }
    
    private func textFieldValueInit() {
        titleTextField.rx.text.onNext(ChallengeDetailTitleInputViewNameSpace.textFieldDefaultText)
        textCountingView.molecularLabel.rx.text.onNext("0")
        textCountingView.molecularLabel.rx.textColor.onNext(UIColor(named: "gray_600"))
    }
    
    private func isTextClearButon(_ state: Bool) {
        if state {
            textFieldRightView.insertArrangedSubview(secondSpacingView, at: 2)
            textFieldRightView.insertArrangedSubview(textClearButton, at: 3)
        } else {
            textFieldRightView.removeArrangedSubview(secondSpacingView)
            secondSpacingView.removeFromSuperview()
            
            textFieldRightView.removeArrangedSubview(textClearButton)
            textClearButton.removeFromSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeDetailTitleInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailTitleInputView_Presentable()
    }
    
    struct ChallengeDetailTitleInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeDetailTitleInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
