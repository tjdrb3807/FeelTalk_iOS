//
//  HomeQuestionAnswerButton.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class HomeQuestionAnswerButton: UIButton {
    private lazy var totalHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.width / 100) * 1.06
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.text = "답변하기"
        label.font = UIFont(name: "pretendard-medium", size: 18.0)
        label.textColor = .white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_white_right_arrow")
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        layer.cornerRadius = ((UIScreen.main.bounds.height / 100) * 6.28) / 2
        backgroundColor = .black
    }
    
    private func setConfig() {
        [answerLabel, rightArrowImageView].forEach { totalHorizontalStackView.addArrangedSubview($0) }
        
        answerLabel.snp.makeConstraints { $0.height.equalToSuperview() }
        
        rightArrowImageView.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 5.33)
            $0.height.equalTo(rightArrowImageView.snp.width)
        }
        
        addSubview(totalHorizontalStackView)
        
        totalHorizontalStackView.snp.makeConstraints {
            $0.width.equalTo((UIScreen.main.bounds.width / 100) * 22.93)
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 3.32)
            $0.center.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeQuestionAnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        HomeQuestionAnswerButton_Presentable()
    }
    
    struct HomeQuestionAnswerButton_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeQuestionAnswerButton()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
