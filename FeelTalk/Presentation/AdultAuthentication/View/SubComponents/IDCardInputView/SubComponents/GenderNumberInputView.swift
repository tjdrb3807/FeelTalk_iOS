//
//  GenderNumberInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class GenderNumberInputView: UIView {
    private let disposeBag = DisposeBag()
    
    private lazy var dotIcon: UIImageView = { UIImageView(image: UIImage(named: GenderNumberInputViewNameSpace.dotIconImage)) }()
    
    lazy var genderNumberInputTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                size: GenderNumberInputViewNameSpace.genderNumberInputTextFieldTextSize)
        textField.keyboardType = .numberPad
        textField.backgroundColor = .clear
        textField.tintColor = UIColor(named: CommonColorNameSpace.main500)
        
        let leftPaddingView = UIView(frame: CGRect(origin: .zero,
                                                   size: CGSize(width: GenderNumberInputViewNameSpace.genderNumberInputTextFieldPaddingViewWidth,
                                                                height: frame.height)))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(origin: .zero,
                                                    size: CGSize(width: GenderNumberInputViewNameSpace.genderNumberInputTextFieldPaddingViewWidth,
                                                                 height: frame.height)))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        textField.inputAccessoryView = genderNumberTextFiledInputAccessoryView
        
        return textField
    }()
    
    private lazy var asteriskIconStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = GenderNumberInputViewNameSpace.asteriskIconStackViewSpacing
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    lazy var genderNumberTextFiledInputAccessoryView: CustomToolbar = { CustomToolbar(type: .ongoing) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setProperties()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { v, _ in
                v.genderNumberInputTextField.becomeFirstResponder()
            }.disposed(by: disposeBag)
        
        Observable<Bool>
            .merge(genderNumberInputTextField.rx.controlEvent(.editingDidBegin).map { true },
                   genderNumberInputTextField.rx.controlEvent(.editingDidEnd).map { false }
            ).bind(to: dotIcon.rx.isHidden)
            .disposed(by: disposeBag)
        
        genderNumberInputTextField.rx.text.orEmpty
            .withUnretained(self)
            .bind { v, text in
                v.hiddenDotIcon(text)
                v.limitChar(text)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() { backgroundColor = .clear }
    
    private func addSubComponents() {
        addViewSubComponents()
        addAsteriskStackViewSubComponents()
    }
    
    private func setConstraints() {
        makeGenderNumberInputTextFieldConstraints()
        makeDotIconConstraints()
        makeAsteriskIconStackViewConstraints()
    }
}

extension GenderNumberInputView {
    private func addViewSubComponents() {
        [genderNumberInputTextField, dotIcon, asteriskIconStackView].forEach { addSubview($0) }
    }
    
    private func makeGenderNumberInputTextFieldConstraints() {
        genderNumberInputTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(GenderNumberInputViewNameSpace.genderNumberInputTextFieldTopInset)
            $0.leading.equalToSuperview().inset(GenderNumberInputViewNameSpace.genderNumberInputTextFieldLeadingInset)
            $0.bottom.equalToSuperview().inset(GenderNumberInputViewNameSpace.genderNumberInputTextFieldBottomInset)
            $0.width.equalTo(GenderNumberInputViewNameSpace.genderNumberInputTextFieldWidth)
        }
    }
    
    private func makeDotIconConstraints() {
        dotIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(GenderNumberInputViewNameSpace.dotIconTopInset)
            $0.leading.equalToSuperview().inset(GenderNumberInputViewNameSpace.dotIconLeadingInset)
            $0.bottom.equalToSuperview().inset(GenderNumberInputViewNameSpace.dotIconBottomInset)
            $0.width.equalTo(GenderNumberInputViewNameSpace.dotIconWidth)
            
        }
    }
    
    private func makeAsteriskIconStackViewConstraints() {
        asteriskIconStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(GenderNumberInputViewNameSpace.asteriskIconStackViewTopInset)
            $0.leading.equalToSuperview().inset(GenderNumberInputViewNameSpace.asteriskIconStackViewLeadingInset)
            $0.trailing.equalToSuperview().inset(GenderNumberInputViewNameSpace.asteriskIconStackViewTrailingInset)
            $0.bottom.equalToSuperview().inset(GenderNumberInputViewNameSpace.asteriskIconStackViewBottomInset)
        }
    }
    
    private func addAsteriskStackViewSubComponents() {
        for _ in 1...GenderNumberInputViewNameSpace.asteriskIconCount {
            let asteriskIcon = UIImageView(image: UIImage(named: GenderNumberInputViewNameSpace.asteriskIconImage))
            asteriskIconStackView.addArrangedSubview(asteriskIcon)
        }
    }
}

extension GenderNumberInputView {
    private func hiddenDotIcon(_ text: String) {
        if !text.isEmpty {
            self.dotIcon.rx.isHidden.onNext(true)
        }
    }
    
    private func limitChar(_ text: String) {
        if text.count > GenderNumberInputViewNameSpace.genderNumberInputTextFieldMaxTextCount {
            let index = text.index(text.startIndex,
                                   offsetBy: GenderNumberInputViewNameSpace.genderNumberInputTextFieldMaxTextCount)
            self.genderNumberInputTextField.text = String(text[..<index])
        }
    }
}

#if DEBUG

import SwiftUI

struct GenderNumberInputView_Previews: PreviewProvider {
    static var previews: some View {
        GenderNumberInputView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: GenderNumberInputViewNameSpace.width,
                   height: GenderNumberInputViewNameSpace.height,
                   alignment: .center)
    }
    
    struct GenderNumberInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            GenderNumberInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
