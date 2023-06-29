//
//  QuestionViewTopSection.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionViewTopSection: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 1.47
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var coupleProfileInfoView = QuestionCoupleInfoView()
    private lazy var questionLabel = QuestionAnswerSectionView()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_question_note")
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = UIColor(named: "main_500")
        layer.cornerRadius = 8.0
    }
    
    private func setConfig() {
        [coupleProfileInfoView, questionLabel].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        coupleProfileInfoView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 3.94)
        }
        
        questionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 14.28)
        }
        
        [totalVerticalStackView, backgroundImageView].forEach { addSubview($0) }
        
        totalVerticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIScreen.main.bounds.height / 100) * 2.95)
            $0.leading.trailing.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { $0.trailing.bottom.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct QuestionViewTopSection_Previews: PreviewProvider {
    static var previews: some View {
        QuestionViewTopSection_Presentabel()
    }
    
    struct QuestionViewTopSection_Presentabel: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionViewTopSection()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
