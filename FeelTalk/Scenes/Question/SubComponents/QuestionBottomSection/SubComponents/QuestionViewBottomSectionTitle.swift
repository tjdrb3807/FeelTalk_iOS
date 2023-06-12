//
//  QuestionViewBottomSectionTitle.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionViewBottomSectionTitle: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "우리의 필로우톡"
        label.font = UIFont(name: "pretendard-medium", size: 18.0)
        label.textColor = .black
        label.backgroundColor = .clear
        
        return label
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
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            $0.centerY.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionViewBottomSectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        QuestionViewBottomSectionTitle_Presentable()
    }
    
    struct QuestionViewBottomSectionTitle_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionViewBottomSectionTitle()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
