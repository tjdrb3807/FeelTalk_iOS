//
//  InquiryEmailInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class InquiryEmailInputView: UIStackView {
    private let disposeBag = DisposeBag()
    
    private lazy var titleView: CustomTitleView = { CustomTitleView(type: .receiveEmail) }()
    
    lazy var emailInputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                size: InquiryEmailInputViewNameSpace.emailInputTextFieldTextSize)
        textField.textColor = .black
        textField.backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        textField.layer.borderWidth = InquiryEmailInputViewNameSpace.emailInputTextFieldBorderWidth
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = InquiryEmailInputViewNameSpace.emailInputTextFieldCornerRadius
        textField.clipsToBounds = true
        textField.tintColor = UIColor(named: CommonColorNameSpace.main500)
        
        let leftPaddingView = UIView(frame: CGRect(origin: .zero,
                                                   size: CGSize(width: InquiryEmailInputViewNameSpace.emailInputTextFieldLeftPaddingViewWidth,
                                                                height: textField.frame.height)))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        textField.setClearButton(with: UIImage(named: InquiryEmailInputViewNameSpace.emailInputTextFieldClearButtonImage)!,
                                 mode: .whileEditing)
        textField.setPlaceholder(text: InquiryEmailInputViewNameSpace.emailInputTextFieldPlaceholderText,
                                 color: UIColor(named: CommonColorNameSpace.gray400)!)
        textField.inputAccessoryView = emailInputTextFieldAccessoryView
        
        return textField
    }()
    
    lazy var emailInputTextFieldAccessoryView: CustomToolbar = { CustomToolbar(type: .completion) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstratins()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        Observable
            .merge(emailInputTextField.rx.controlEvent(.editingDidBegin).map { true },
                   emailInputTextField.rx.controlEvent(.editingDidEnd).map { false })
            .withUnretained(self)
            .bind { v, state in
                v.emailInputTextField.updateBorderColor(isEditingBegin: state)
                v.emailInputTextField.updateBackgourndColor(isEditingBegin: state)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = InquiryEmailInputViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        [titleView, emailInputTextField].forEach { addArrangedSubview($0) }
    }
    
    private func setConstratins() {
        makeTitleViewConstraints()
        makeEailInputTextFieldConstraints()
    }
}

extension InquiryEmailInputView {
    private func makeTitleViewConstraints() {
        titleView.snp.makeConstraints {
            
            $0.height.equalTo(CustomTitleViewNameSpace.height)
        }
    }
    
    private func makeEailInputTextFieldConstraints() {
        emailInputTextField.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(InquiryEmailInputViewNameSpace.emailInputTextFieldHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct InquiryEmailInputView_Previews: PreviewProvider {
    static var previews: some View {
        InquiryEmailInputView_Presentable()
    }
    
    struct InquiryEmailInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            InquiryEmailInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
