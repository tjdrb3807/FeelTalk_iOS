//
//  MyAnswerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyAnswerView: UIStackView {
    let model = PublishRelay<Question>()
    private let disposeBag = DisposeBag()
    
    private lazy var inputViewTitle: CustomInputViewTitle = { CustomInputViewTitle(type: .myAnswer, isRequiredInput: false) }()
    
    lazy var answerInputView: CustomTextView = { CustomTextView(placeholder: MyAnswerViewNameSpace.answerInputViewPlaceholder,
                                                                maxTextCout: MyAnswerViewNameSpace.answerInputViewMaxNumberOfChar) }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bind()
        self.setAttributes()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        model
            .withUnretained(self)
            .bind { v, event in
                v.setupModel(with: event)
            }.disposed(by: disposeBag)
    }
    
    private func setAttributes() {
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = MyAnswerViewNameSpace.spacing
    }
    
    private func addSubComponents() {
        [inputViewTitle, answerInputView].forEach { self.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        inputViewTitle.snp.makeConstraints {
            $0.height.equalTo(MyAnswerViewNameSpace.inputViewTitleHeight)
        }
        
        answerInputView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(MyAnswerViewNameSpace.answerInputViewHeight)
        }
    }
}

extension MyAnswerView {
    private func setupModel(with model: Question) {
        if model.isMyAnswer {
            answerInputView.textView.rx.textColor.onNext(.black)
            answerInputView.textView.rx.text.onNext(model.myAnser)
            answerInputView.textView.rx.isEditable.onNext(false)
            answerInputView.countingView.rx.isHidden.onNext(true)
        }
    }
}

#if DEBUG

import SwiftUI

struct MyAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        MyAnswerView_Presentable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - (CommonConstraintNameSpace.leadingInset + CommonConstraintNameSpace.trailingInset),
                   height: MyAnswerViewNameSpace.height,   
                   alignment: .center)
    }
    
    struct MyAnswerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            MyAnswerView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
