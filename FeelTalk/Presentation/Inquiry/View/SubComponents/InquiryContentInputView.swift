//
//  InquiryTitleInputView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class InquiryContentInputView: UIStackView {
    private let disposeBag = DisposeBag()
    
    private lazy var titleView: CustomTitleView = { CustomTitleView(type: .inquiryInfo) }()
    
    lazy var titleInputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                                size: InquiryContentInputViewNameSpace.titleInputTextFieldFontSize)
        textField.textColor = .black
        textField.backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        textField.layer.borderWidth = InquiryContentInputViewNameSpace.titleInputTextFieldBorderWidth
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = InquiryContentInputViewNameSpace.titleInputTextFieldCornerRadius
        textField.clipsToBounds = true
        textField.tintColor = UIColor(named: CommonColorNameSpace.main500)
        
        let leftPaddingView = UIView(frame: CGRect(origin: .zero,
                                                   size: CGSize(width: InquiryContentInputViewNameSpace.titleInputTextFieldLeftPaddingViewWidth,
                                                                height: textField.frame.height)))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        textField.setClearButton(with: UIImage(named: "icon_text_clear")!,
                                 mode: .whileEditing)
        textField.setPlaceholder(text: InquiryContentInputViewNameSpace.titleInputTextFieldPlaceholderText,
                                 color: UIColor(named: CommonColorNameSpace.gray400)!)
        textField.inputAccessoryView = titleInputTextViewAccessoryView
        
        return textField
    }()
    
    lazy var titleInputTextViewAccessoryView: CustomToolbar = { CustomToolbar(type: .ongoing) }()
    
    lazy var contentInputTextView: CustomTextView = {
        let customTextView = CustomTextView(placeholder: InquiryContentInputViewNameSpace.contentInputTextViewPlaceholder, maxTextCout: InquiryContentInputViewNameSpace.contentInputTextViewMaxTextCount)
        customTextView.textView.inputAccessoryView = contentInputTextViewAccessoryView
        
        return customTextView
    }()
    
    lazy var contentInputTextViewAccessoryView: CustomToolbar = { CustomToolbar(type: .ongoing) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        Observable
            .merge(titleInputTextField.rx.controlEvent(.editingDidBegin).map { true },
                   titleInputTextField.rx.controlEvent(.editingDidEnd).map { false })
            .withUnretained(self)
            .bind { v, state in
                v.titleInputTextField.updateBorderColor(isEditingBegin: state)
                v.titleInputTextField.updateBackgourndColor(isEditingBegin: state)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = InquiryContentInputViewNameSpace.spacing
        backgroundColor = .clear
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeTitleViewConstraints()
        makeTitleInputTextFieldConstraints()
        makeContentInputTextViewConstraints()
    }
}

extension InquiryContentInputView {
    private func addViewSubComponents() {
        [titleView, titleInputTextField, contentInputTextView].forEach { addArrangedSubview($0) }
    }
    
    private func makeTitleViewConstraints() {
        titleView.snp.makeConstraints { $0.height.equalTo(CustomTitleViewNameSpace.height) }
    }
    
    private func makeTitleInputTextFieldConstraints() {
        titleInputTextField.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(InquiryContentInputViewNameSpace.titleInputTextFieldHeight) }
    }
    
    private func makeContentInputTextViewConstraints() {
        contentInputTextView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(InquiryContentInputViewNameSpace.contentInputTextViewHeight)
        }
    }
}

#if DEBUG

import SwiftUI

struct InquiryContentInputView_Previews: PreviewProvider {
    static var previews: some View {
        InquiryContentInputView_Presentable()
    }
    
    struct InquiryContentInputView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            InquiryContentInputView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
