//
//  AdultAuthNumberInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdultAuthNumberInputView: UIView {
    private let isEditing = BehaviorRelay<Bool>(value: false)
    let isRequested = PublishRelay<AdultAuthNumberRequestState>()
    private let disposeBag = DisposeBag()
    
    lazy var authNumberInputView: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                size: AdultAuthNumberInputViewNameSpace.authNumberInputViewTextSize)
        textField.backgroundColor = .clear
        textField.tintColor = UIColor(named: CommonColorNameSpace.main500)
        textField.keyboardType = .numberPad
        
        textField.setPlaceholder(text: "인증번호를 입력해주세요", color: UIColor(named: CommonColorNameSpace.gray400)!)
        
        textField.inputAccessoryView = authNumberInputAccessoryView
        
        return textField
    }()
    
    lazy var authButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                         size: AdultAuthNumberInputViewNameSpace.authButtonTitleLabelTextSize)
        button.layer.borderWidth = AdultAuthNumberInputViewNameSpace.authButtonBorderWidth
        button.layer.cornerRadius = AdultAuthNumberInputViewNameSpace.authButtonCornerRadius
        button.clipsToBounds = true
        
        return button
    }()
    
    lazy var authNumberInputAccessoryView: CustomToolbar = { CustomToolbar(type: .completion) }()
    
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
        Observable
            .merge(authNumberInputView.rx.controlEvent(.editingDidBegin).map { true }.asObservable(),
                   authNumberInputView.rx.controlEvent(.editingDidEnd).map { false }.asObservable())
            .bind(to: isEditing)
            .disposed(by: disposeBag)
        
        isEditing
            .withUnretained(self)
            .bind { v, state in
                v.updateBackgroundColor(with: state)
                v.updateBorderColor(with: state)
            }.disposed(by: disposeBag)
        
        isRequested
            .withUnretained(self)
            .bind { v, state in
                v.updateAuthButtonProperties(with: state)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        layer.borderWidth = AdultAuthNumberInputViewNameSpace.borderWidth
        layer.cornerRadius = AdultAuthNumberInputViewNameSpace.cornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeAuthNumberInputViewConstraints()
        makeAuthButtonConstraints()
    }
}

extension AdultAuthNumberInputView {
    private func addViewSubComponents() { [authNumberInputView, authButton].forEach { addSubview($0) } }
    
    private func makeAuthNumberInputViewConstraints() {
        authNumberInputView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(AdultAuthNumberInputViewNameSpace.authNumberInputViewTopInset)
            $0.leading.equalToSuperview().inset(AdultAuthNumberInputViewNameSpace.authNumberInputViewLeadingInset)
            $0.bottom.equalToSuperview().inset(AdultAuthNumberInputViewNameSpace.authNumberInputViewBottomInset)
            $0.trailing.equalTo(authButton.snp.leading)
        }
    }
    
    private func makeAuthButtonConstraints() {
        authButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(AdultAuthNumberInputViewNameSpace.authButtonTrailingInset)
            $0.width.equalTo(AdultAuthNumberInputViewNameSpace.authButtonDefaultWidth)
            $0.height.equalTo(AdultAuthNumberInputViewNameSpace.authButtonHeight)
            $0.centerY.equalToSuperview()
        }
    }
}

extension AdultAuthNumberInputView {
    private func updateBackgroundColor(with state: Bool) {
        state ?
        rx.backgroundColor.onNext(.white) :
        rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.gray200))
    }
    
    private func updateBorderColor(with state: Bool) {
        state ?
        layer.rx.borderColor.onNext(UIColor(named: CommonColorNameSpace.main500)?.cgColor) :
        layer.rx.borderColor.onNext(UIColor.clear.cgColor)
    }
    
    private func updateAuthButtonProperties(with state: AdultAuthNumberRequestState) {
        switch state {
        case .none:
            authButton.rx.title().onNext("인증요청")
            authButton.setTitleColor(.white, for: .normal)
            authButton.rx.backgroundColor.onNext(UIColor(named: CommonColorNameSpace.main500))
            authButton.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
        case .requested:
            authButton.rx.title().onNext("재요청")
            authButton.setTitleColor(.black, for: .normal)
            authButton.rx.backgroundColor.onNext(.white)
            authButton.layer.rx.borderColor.onNext(UIColor.black.cgColor)
        }
    }
}

#if DEBUG

import SwiftUI

struct AdultAuthNumberInputView_Previews: PreviewProvider {
    static var previews: some View {
        AdultAuthNumberInputView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: AdultAuthNumberInputViewNameSpace.height,
                   alignment: .center)
    }
    
    struct AdultAuthNumberInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            let v = AdultAuthNumberInputView()
            v.isRequested.accept(.none)
            
            return v
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
