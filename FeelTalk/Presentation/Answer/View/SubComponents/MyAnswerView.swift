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
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = MyAnswerViewNameSpace.titleLabelText
        label.textColor = UIColor(named: MyAnswerViewNameSpace.titleLabelTextColor)
        label.textAlignment = .left
        label.font = UIFont(name: MyAnswerViewNameSpace.titleLabelTextFont,
                            size: MyAnswerViewNameSpace.titleLabelTextSize)
        
        return label
    }()
    
    lazy var answerTextView: UITextView = {
        let textView = UITextView()
        textView.text = MyAnswerViewNameSpace.answerTextViewPlaceHolderText
        textView.textColor = UIColor(named: MyAnswerViewNameSpace.answerTextViewPlaceHolderTextColor)
        textView.font = UIFont(name: MyAnswerViewNameSpace.answerTextViewTextFont,
                               size: MyAnswerViewNameSpace.answerTextViewTextSize)
        textView.backgroundColor = UIColor(named: MyAnswerViewNameSpace.answerTextViewBackgroundColor)
        textView.layer.cornerRadius = MyAnswerViewNameSpace.answerTextViewCornerRadius
        textView.tintColor = UIColor(named: MyAnswerViewNameSpace.answerTextViewTintColor)
        textView.clipsToBounds = true
        
        textView.textContainerInset = UIEdgeInsets(top: MyAnswerViewNameSpace.answerTextViewContainerTopInset,
                                                   left: MyAnswerViewNameSpace.answerTextViewContainerLeftInset,
                                                   bottom: MyAnswerViewNameSpace.answerTextViewContainerBottomInset,
                                                   right: MyAnswerViewNameSpace.answerTextViewContainerRightInset)
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.layer.borderWidth = MyAnswerViewNameSpace.answerTextViewBorderWitdh
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
        self.isPlaceHolder()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = MyAnswerViewNameSpace.spacing
        self.isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        [titleLabel, answerTextView].forEach { self.addArrangedSubview($0) }
    }
}

extension MyAnswerView {
    private func isPlaceHolder() {
        answerTextView.rx.didBeginEditing
            .bind { [self] _ in
                if answerTextView.textColor == UIColor(named: MyAnswerViewNameSpace.answerTextViewPlaceHolderTextColor) {
                    answerTextView.rx.text.onNext(nil)
                    answerTextView.rx.textColor.onNext(.black)
                }
                answerTextView.layer.rx.borderColor.onNext(UIColor(named: MyAnswerViewNameSpace.answerTextViewBaseUpdateBorderColor)?.cgColor)
                answerTextView.rx.backgroundColor.onNext(.white)
            }.disposed(by: disposeBag)
        
        answerTextView.rx.didEndEditing
            .bind { [self] _ in
                if answerTextView.text.isEmpty {
                    answerTextView.rx.text.onNext(MyAnswerViewNameSpace.answerTextViewPlaceHolderText)
                    answerTextView.rx.textColor.onNext(UIColor(named: MyAnswerViewNameSpace.answerTextViewPlaceHolderTextColor))
                }
                answerTextView.layer.rx.borderColor.onNext(UIColor.clear.cgColor)
                answerTextView.rx.backgroundColor.onNext(UIColor(named: MyAnswerViewNameSpace.answerTextViewBackgroundColor))
            }.disposed(by: disposeBag)
    }
    
    func setData(with model: Question) {
        if model.isMyAnswer {
            answerTextView.rx.text.onNext(model.myAnser)
            answerTextView.rx.isEditable.onNext(false)
            answerTextView.rx.textColor.onNext(.black)
        }
    }
}

#if DEBUG

import SwiftUI

struct MyAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        MyAnswerView_Presentable()
    }
    
    struct MyAnswerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            MyAnswerView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
