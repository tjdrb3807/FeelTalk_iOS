//
//  CustomTextView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CustomTextView: UIView {
    var placeholder: String
    var maxTextCount: Int
    private let disposeBag = DisposeBag()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.text = placeholder
        textView.textColor = UIColor(named: CommonColorNameSpace.gray400)
        textView.font = UIFont(name: CommonFontNameSpace.pretendardRegular,
                               size: CustomTextViewNameSpace.textViewTextSize)
        textView.backgroundColor = UIColor(named: CommonColorNameSpace.gray200)
        textView.layer.borderWidth = CustomTextViewNameSpace.textViewBorderWidth
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.layer.cornerRadius = CustomTextViewNameSpace.textViewCornerRadius
        textView.clipsToBounds = true
        textView.tintColor = UIColor(named: CommonColorNameSpace.main500)
        
        textView.textContainerInset = UIEdgeInsets(top: CustomTextViewNameSpace.textViewTextContainerTopInset,
                                                   left: CustomTextViewNameSpace.textViewTextContainerLeftInset,
                                                   bottom: CustomTextViewNameSpace.textViewTextContainerBottomInset,
                                                   right: CustomTextViewNameSpace.textViewTextContainerRightInset)
        textView.isScrollEnabled = true
        textView.autocorrectionType = .no
        textView.delegate = self
        
        return textView
    }()
    
    lazy var countingView: TextCountingView = { TextCountingView(denominator: maxTextCount) }()
    
    init(placeholder: String, maxTextCout: Int) {
        self.placeholder = placeholder
        self.maxTextCount = maxTextCout
        super.init(frame: .zero)
        
        self.bind()
        self.setConfigurations()
        self.addSubComponents()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        Observable
            .merge(textView.rx.didBeginEditing.map { true },
                   textView.rx.didEndEditing.map { false })
            .withUnretained(self)
            .bind { v, state in
                v.textView.updateBorderColor(isEditingBegin: state)
                v.textView.updateBackgroundColor(isEditingBegin: state)
            }.disposed(by: disposeBag)
        
        textView.rx.didBeginEditing
            .withLatestFrom(textView.rx.text.orEmpty)
            .withUnretained(self)
            .filter { $1 == $0.placeholder }
            .bind { v, _ in
                v.textView.rx.text.onNext(nil)
                v.textView.rx.textColor.onNext(.black)
            }.disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .withLatestFrom(textView.rx.text.orEmpty)
            .withUnretained(self)
            .filter { $1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .bind { v, _ in
                v.textView.rx.text.onNext(v.placeholder)
                v.textView.rx.textColor.onNext(UIColor(named: CommonColorNameSpace.gray400))
                v.countingView.molecularCount.accept(0)
            }.disposed(by: disposeBag)
        
        textView.rx.text.orEmpty
            .withUnretained(self)
            .filter { $1 != $0.placeholder }
            .map { $1.count }
            .bind(to: countingView.molecularCount)
            .disposed(by: disposeBag)
    }
    
    private func setConfigurations() {
        backgroundColor = .clear
        layer.cornerRadius = CustomTextViewNameSpace.textViewCornerRadius
        clipsToBounds = true
    }
    
    private func addSubComponents() {
        addViewSubComponents()
    }
    
    private func setConstraints() {
        makeTextViewConstratins()
        makeCountingViewConstraints()
    }
}

extension CustomTextView {
    private func addViewSubComponents() { [textView, countingView].forEach { addSubview($0) } }
    
    private func makeTextViewConstratins() {
        textView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func makeCountingViewConstraints() {
        countingView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(CustomTextViewNameSpace.countingViewTrailingInset)
            $0.bottom.equalToSuperview().inset(CustomTextViewNameSpace.countingViewBottomInset)
        }
    }
}

extension CustomTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }

        // 글자수 제한
        if text.count > self.maxTextCount {
            textView.text = String(text.prefix(maxTextCount))
        }
    }
}

#if DEBUG

import SwiftUI

struct CustomTextView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextView_Presentable()
    }
    
    struct CustomTextView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            CustomTextView(placeholder: "페이지 에러, 건의사항, 필로우톡에게 궁금한 점 등 자유롭게 문의 내용을 작성해 주세요 !",
                           maxTextCout: 100)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
