//
//  QuestionInputViewTitleLabel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionInputViewTitleLabel: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "난 이게 가장 좋더라!"
        label.font = UIFont(name: "pretendard-regular", size: 24.0)
        label.textColor = .black
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "당신이 가장 좋아하는 스킨십은?"
        label.font = UIFont(name: "pretendard-regular", size: 24.0)
        label.textColor = .black
        label.backgroundColor = .clear
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setAttribute()
        self.setConfig()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() { backgroundColor = .clear }
    
    private func setConfig() {
        [headerLabel, bodyLabel].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionInputViewTitleLabel_Previews: PreviewProvider {
    static var previews: some View {
        QuestionInputViewTitleLabel_Presentable()
            .edgesIgnoringSafeArea(.leading)
    }
    
    struct QuestionInputViewTitleLabel_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionInputViewTitleLabel()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
