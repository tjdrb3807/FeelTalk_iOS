//
//  QuestionInputViewPartnerAnswerSection.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionInputViewPartnerAnswerSection: UIView {
    private var isPartnerAnser: Bool = true
    
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
        label.text = "연인의 답변"
        label.font = UIFont(name: "pretendard-bold", size: 12.0)
        label.textColor = UIColor(named: "gray_500")
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.sizeToFit()
        
        return label
    }()
    
    lazy var answerRequestButton: UIButton = {
        let button = UIButton()
        
        if isPartnerAnser {
            button.setTitle("답변을 등록했어요 😍", for: .normal)
            button.backgroundColor = UIColor(named: "gray_200")
            button.isEnabled = false
        } else {
            button.setTitle("쿡 찔러서 답변 요청하기", for: .normal)
            button.backgroundColor = UIColor(named: "main_300")
            button.layer.borderColor = UIColor(named: "main_500")?.cgColor
            button.layer.borderWidth = 1.0
            button.isEnabled = true
        }
        
        button.titleLabel?.font = UIFont(name: "pretendard-medium", size: 18.0)
        button.setTitleColor(UIColor(named: "main_500"), for: .normal)
        button.layer.cornerRadius = 8.0
        
        return button
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
        [titleLabel, answerRequestButton].forEach { totalVerticalStackView.addArrangedSubview($0) }
    
        titleLabel.snp.makeConstraints { $0.height.equalTo(titleLabel.intrinsicContentSize) }
        
        answerRequestButton.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.26) }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionInputViewPartnerAnswerSection_Previews: PreviewProvider {
    static var previews: some View {
        QuestionInputViewPartnerAnswerSection_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct QuestionInputViewPartnerAnswerSection_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionInputViewPartnerAnswerSection()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
