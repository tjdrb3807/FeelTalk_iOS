//
//  AdultAuthIDCardNumberInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthIDCardNumberInputView: UIStackView {
    let isEditing = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    lazy var birthdayInputTextField: UITextField = {
        let textField = UITextField()
        textField.setPlaceholder(text: AdultAuthIDCardNumberInputViewNameSpace.birthdayInputTextFieldPlaceholder,
                                 color: UIColor(named: CommonColorNameSpace.gray400)!)
        textField.font = UIFont(name: CommonFontNameSpace.pretendardMedium,
                                size: AdultAuthIDCardNumberInputViewNameSpace.birthdayInputTextFieldTextSize)
        textField.textColor = .black
        textField.tintColor = UIColor(named: CommonColorNameSpace.main500)
        textField.backgroundColor = .clear
        
        let leftPaddingView = UIView(frame: CGRect(origin: .zero,
                                                   size: CGSize(width: AdultAuthIDCardNumberInputViewNameSpace.birthdayInputTextFieldPaddingViewWidth,
                                                                height: frame.height)))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(origin: .zero,
                                                    size: CGSize(width: AdultAuthIDCardNumberInputViewNameSpace.birthdayInputTextFieldPaddingViewWidth,
                                                                 height: frame.height)))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        textField.keyboardType = .numberPad
        
        textField.inputAccessoryView = birthdayInputTextFieldInputAccesscoryView
        
        return textField
    }()
    
    private lazy var hyphenLabel: UILabel = {
        let label = UILabel()
        label.text = AdultAuthIDCardNumberInputViewNameSpace.hyphenLabelText
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                            size: AdultAuthIDCardNumberInputViewNameSpace.hyphenLabelTextSize)
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var genderNumberInputView: GenderNumberInputView = { GenderNumberInputView() }()
    
    lazy var birthdayInputTextFieldInputAccesscoryView: CustomToolbar = { CustomToolbar(type: .ongoing) }()
    
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
        Observable<Bool>
            .merge(birthdayInputTextField.rx.controlEvent(.editingDidBegin).map { true },
                   birthdayInputTextField.rx.controlEvent(.editingDidEnd).map { false },
                   genderNumberInputView.genderNumberInputTextField.rx.controlEvent(.editingDidBegin).map { true },
                   genderNumberInputView.genderNumberInputTextField.rx.controlEvent(.editingDidEnd).map { false })
            .bind(to: isEditing)
            .disposed(by: disposeBag)
        
        isEditing
            .withUnretained(self)
            .bind { v, state in
                v.updateBorderColor(with: state)
                v.updateBackgroundColor(with: state)
            }.disposed(by: disposeBag)
        
        birthdayInputTextField.rx.text.orEmpty
            .withUnretained(self)
            .bind { v, text in
                v.limitChar(text)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        spacing = AdultAuthIDCardNumberInputViewNameSpace.spacing
        layer.cornerRadius = AdultAuthIDCardNumberInputViewNameSpace.cornerRadius
        layer.borderWidth = AdultAuthIDCardNumberInputViewNameSpace.borderWidth
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponens()
    }
    
    private func setConstraints() {
        makeBirthdayInputTextFieldConstraints()
        makeGenderNumberInputViewConstraints()
    }
}

extension AdultAuthIDCardNumberInputView {
    private func addViewSubComponens() {
        [birthdayInputTextField, hyphenLabel, genderNumberInputView].forEach { addArrangedSubview($0) }
    }
    
    private func makeBirthdayInputTextFieldConstraints() {
        birthdayInputTextField.snp.makeConstraints {
            $0.width.equalTo(AdultAuthIDCardNumberInputViewNameSpace.birthdayInputTextFieldWidth)
        }
    }
    
    private func makeGenderNumberInputViewConstraints() {
        genderNumberInputView.snp.makeConstraints {
            $0.width.equalTo(GenderNumberInputViewNameSpace.width)
        }
    }
}

extension AdultAuthIDCardNumberInputView {
    private func updateBorderColor(with state: Bool) {
        state ?
        layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.main500)?.cgColor) :
        layer.rx.borderColor.onNext(UIColor.clear.cgColor)
    }
    
    private func updateBackgroundColor(with state: Bool) {
        state ?
        rx.backgroundColor.onNext(.white) :
        rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray200))
    }
    
    private func limitChar(_ text: String) {
        if text.count > AdultAuthIDCardNumberInputViewNameSpace.birthdayInputTextFieldLimitCount {
            let index = text.index(text.startIndex, offsetBy: AdultAuthIDCardNumberInputViewNameSpace.birthdayInputTextFieldLimitCount)
            self.birthdayInputTextField.text = String(text[..<index])
        }
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthIDCardNumberInputView_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthIDCardNumberInputView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: AdultAuthIDCardNumberInputViewNameSpace.height,
                   alignment: .center)
    }
    
    struct AdultAuthIDCardNumberInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            AdultAuthIDCardNumberInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
