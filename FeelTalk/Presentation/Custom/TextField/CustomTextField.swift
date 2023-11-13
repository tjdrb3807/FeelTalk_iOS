//
//  CustomTextField.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CustomTextField: UITextField {
    private let disposeBag = DisposeBag()
    
    init(placeholder: String) {
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
        Observable
            .merge(rx.controlEvent(.editingDidBegin).map { true },
                   rx.controlEvent(.editingDidEnd).map { false })
            .withUnretained(self)
            .bind { v, state in
                v.updateBorderColor(isEditingBegin: state)
                v.updateBackgourndColor(isEditingBegin: state)
            }.disposed(by: disposeBag)
    }
    
    private func setProperties() {
        font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                      size: 16.0)
        textColor = .black
        backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 12.0
        
        clipsToBounds = true
        tintColor = UIColor(named: CommonColorNameSpace.main500)
        
        let leftPaddingView = UIView(frame: CGRect(origin: .zero,
                                                   size: CGSize(width: 12.0,
                                                                height: frame.height)))
        leftView = leftPaddingView
        leftViewMode = .always
        
        setClearButton(with: UIImage(named: InquiryEmailInputViewNameSpace.emailInputTextFieldClearButtonImage)!,
                       mode: .whileEditing)
    }
}

#if DEBUG

import SwiftUI

struct CustomTextField_Preview: PreviewProvider {
    static var previews: some View {
        CustomTextField_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width -
                   (CommonConstraintNameSpace.leadingInset +
                    CommonConstraintNameSpace.trailingInset),
                   height: 56,
                   alignment: .center)
    }
    
    struct CustomTextField_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomTextField(placeholder: "Placeholder")
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}
#endif
