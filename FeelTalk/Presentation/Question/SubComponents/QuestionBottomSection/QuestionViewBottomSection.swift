//
//  QuestionViewBottomSection.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionViewBottomSection: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0.0
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var bottomSectionTitle = QuestionViewBottomSectionTitle()
    private lazy var questionList = QuestionViewBottomSectionList()
    
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
        [bottomSectionTitle, questionList].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        bottomSectionTitle.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 7.38) }
        
        questionList.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 39.90) }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

#if DEBUG

import SwiftUI

struct QuestionViewBottomSection_Previews: PreviewProvider {
    static var previews: some View {
        QuestionViewBottomSection_Presentable()
    }
    
    struct QuestionViewBottomSection_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionViewBottomSection()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
