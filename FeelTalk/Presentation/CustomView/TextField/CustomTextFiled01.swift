//
//  CustomTextFiled01.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CustomTextField01: UITextField {
    let useClearButton: Bool
    let maxNumberOfChar: Int
    private let disposeBag = DisposeBag()
    
    private lazy var leftPaddingView: UIView = {
        UIView(frame: CGRect(origin: .zero, size: CGSize(width: CustomTextFiledNameSpace01.leftPaddingViewWidth,
                                                         height: frame.height)))
    }()
    
    var charCountingView: TextCountingView?
    
    init(placeholder: String, useClearButton: Bool, textLimit: Int) {
        self.useClearButton = useClearButton
        self.maxNumberOfChar = textLimit
        
        super.init(frame: .zero)
        
        self.setPlaceholder(text: placeholder,
                            color: UIColor(named: CommonColorNameSpace.gray400)!)
        
        self.bind()
        self.setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        let isFocused = Observable.merge(rx.controlEvent(.editingDidBegin).map { true },
                                         rx.controlEvent(.editingDidEnd).map { false })
        
        let isEmpty = rx.text.orEmpty.map { $0.isEmpty }
        
        isFocused
            .withUnretained(self)
            .bind { v, state in
                v.updateBorderColor(isEditingBegin: state)
                v.updateBackgourndColor(isEditingBegin: state)
            }.disposed(by: disposeBag)
        
        if maxNumberOfChar > 0 {
            Observable
                .combineLatest(isFocused, isEmpty)
                .withUnretained(self)
                .bind { v, event in
                    if !event.0 {
                        v.updateCharCountingViewConstraints(isClearButtonHidden: true)
                    } else {
                        if event.1 {
                            v.updateCharCountingViewConstraints(isClearButtonHidden: true)
                        } else {
                            v.updateCharCountingViewConstraints(isClearButtonHidden: false)
                        }
                    }
                }.disposed(by: disposeBag)
            
            rx.text.orEmpty
                .withUnretained(self)
                .bind { v, text in
                    v.limitChar(text)
                }.disposed(by: disposeBag)
        }
    }
    
    private func setProperties() {
        font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                      size: CustomTextFiledNameSpace01.textSize)
        textColor = .black
        tintColor = UIColor(named: CommonColorNameSpace.main500)
        backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        
        layer.borderWidth = CustomTextFiledNameSpace01.borderWidth
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = CustomTextFiledNameSpace01.cornerRadius
        autocorrectionType = .no
        clipsToBounds = true
        
        leftView = leftPaddingView
        leftViewMode = .always
        
        if useClearButton {
            setClearButton(with: UIImage(named: InquiryEmailInputViewNameSpace.emailInputTextFieldClearButtonImage)!,
                           mode: .whileEditing)
        }
        
        if maxNumberOfChar > 0 { configCharCountingView(maxNumberOfChar) }
    }
}

extension CustomTextField01 {
    private func configCharCountingView(_ maxNumberOfChar: Int) {
        self.charCountingView = TextCountingView(denominator: maxNumberOfChar)
        
        addSubview(charCountingView!)
        
        charCountingView!.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(CustomTextFiledNameSpace01.charCountingViewDefaultTrailingInset)
        }
        
        rx.text.orEmpty
            .map { $0.count }
            .bind(to: charCountingView!.molecularCount)
            .disposed(by: disposeBag)
    }
    
    private func updateCharCountingViewConstraints(isClearButtonHidden: Bool) {
        if isClearButtonHidden {
            charCountingView!.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(CustomTextFiledNameSpace01.charCountingViewDefaultTrailingInset)
            }
        } else {
            charCountingView!.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(CustomTextFiledNameSpace01.charCountingViewUpdateTrailingInset)
            }
        }
    }
}

extension CustomTextField01 {
    private func limitChar(_ text: String) {
        if text.count > maxNumberOfChar {
            let index = text.index(text.startIndex,
                                   offsetBy: maxNumberOfChar)
            
            self.text = String(text[..<index])
        }
    }
}

#if DEBUG

import SwiftUI

struct CustomTextField01_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField01_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: 56.0,
                   alignment: .center)
    }
    
    struct CustomTextField01_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomTextField01(placeholder: "placeholder",
                              useClearButton: true,
                              textLimit: 10)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
