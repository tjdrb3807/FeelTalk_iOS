//
//  PartnerAnswerView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import UIKit
import SnapKit

final class PartnerAnswerView: UIStackView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = PartnerAnswerViewNameSpace.titleLabelText
        label.textColor = UIColor(named: PartnerAnswerViewNameSpace.titleLabelTextColor)
        label.textAlignment = .left
        label.font = UIFont(name: PartnerAnswerViewNameSpace.titleLabelTextFont,
                            size: PartnerAnswerViewNameSpace.titleLabelTextSize)
        
        return label
    }()
    
    private lazy var answerTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont(name: PartnerAnswerViewNameSpace.answerTextViewTextFont,
                               size: PartnerAnswerViewNameSpace.answerTextViewTextSize)
        textView.backgroundColor = UIColor(named: PartnerAnswerViewNameSpace.answerTextViewBackgroundColor)
        textView.layer.cornerRadius = PartnerAnswerViewNameSpace.answerTextViewCornerRadius
        textView.clipsToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: PartnerAnswerViewNameSpace.answerTextViewContainerTopInset,
                                                   left: PartnerAnswerViewNameSpace.answerTextViewContainerLeftInset,
                                                   bottom: PartnerAnswerViewNameSpace.answerTextViewContainerBottomInset,
                                                   right: PartnerAnswerViewNameSpace.answerTextViewContainerRightInset)
        textView.isEditable = false
        
        return textView
    }()
    
    lazy var noAnswerView: PartnerNoAnswerView = { PartnerNoAnswerView() }()
    lazy var gotAnswerView: PartnerGotAnswerView = { PartnerGotAnswerView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttributes()
        self.addSubComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = PartnerAnswerViewNameSpace.spacing
        self.isUserInteractionEnabled = true
    }
    
    private func addSubComponents() {
        [titleLabel].forEach { self.addArrangedSubview($0) }
    }
}

extension PartnerAnswerView {
    func setData(with model: Question) {
        if model.isMyAnswer && model.isPartnerAnswer {  // 둘 다 답변한 경우
            answerTextView.rx.text.onNext(model.partnerAnser)
            self.addArrangedSubview(answerTextView)
        } else if model.isMyAnswer && !model.isPartnerAnswer {  // 나만 답변한 경우
            self.addArrangedSubview(noAnswerView)
        } else if !model.isMyAnswer && model.isPartnerAnswer {  // 상대만 답변한 경우
            self.addArrangedSubview(gotAnswerView)
        } else {  // 둘 다 답변하지 않은 경우
            self.addArrangedSubview(noAnswerView)
        }
    }
}

#if DEBUG

import SwiftUI

struct PartnerAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerAnswerView_Presentable()
    }
    
    struct PartnerAnswerView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            PartnerAnswerView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
