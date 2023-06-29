//
//  QuestionAnswerSectionView.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionAnswerSectionView: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 1.97
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var questionSectionVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "난 이게 가장 좋더라!"
        label.font = UIFont(name: "pretendard-medium", size: 20.0)
        label.textColor = .white
        label.numberOfLines = 1
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "당신이 가장 좋아하는 스킨십은?"
        label.font = UIFont(name: "pretendard-medium", size: 20.0)
        label.textColor = .white
        label.numberOfLines = 1
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var questionAnswerButton: UIButton = {
        let button = UIButton()
        button.setTitle("답변하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "pretendard-reqular", size: 16.0)
        button.layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 4.92) / 2
        button.backgroundColor = .black
        
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
    
    private func setAttribute() { backgroundColor = UIColor(named: "main_500") }
    
    private func setConfig() {
        [headerLabel, bodyLabel].forEach { questionSectionVerticalStackView.addArrangedSubview($0) }
        
        [questionSectionVerticalStackView, questionAnswerButton].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        questionSectionVerticalStackView.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.38) }
        
        questionAnswerButton.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 21.33)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 4.92)
        }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionAnswerSectionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionAnswerSectionView_Presentable()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct QuestionAnswerSectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionAnswerSectionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
