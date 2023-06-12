//
//  QuestionInputViewMyAnswerSection.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionInputViewMyAnswerSection: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 0.98
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 답변"
        label.font = UIFont(name: "pretendard-bold", size: 12.0)
        label.textColor = UIColor(named: "gray_500")
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    lazy var answerInputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "pretendard-medium", size: 18.0)
        textField.backgroundColor = UIColor(named: "gray_200")
        textField.layer.cornerRadius = 8.0
        textField.placeholder = "질문에 대해 답변을 적어보세요!"
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() { backgroundColor = .clear }
    
    private func setConfig() {
        [titleLabel, answerInputTextField].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        titleLabel.snp.makeConstraints { $0.height.equalTo(titleLabel.intrinsicContentSize) }
        
        answerInputTextField.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 17.24) }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionInputViewMyAnswerSection_Previews: PreviewProvider {
    static var previews: some View {
        QuestionInputViewMyAnswerSection_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct QuestionInputViewMyAnswerSection_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionInputViewMyAnswerSection()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
