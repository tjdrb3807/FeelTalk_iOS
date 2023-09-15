//
//  ChallengeTabItem.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/15.
//

import UIKit
import SnapKit

final class ChallengeTabItem: UIView {
    private let itemType: ChallengeTabType
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        switch itemType {
        case .onGoing: label.text = "진행중"
        case .completed: label.text = "완료"
        }
        
        label.textColor = UIColor(named: "gray_600")
        label.font = UIFont(name: "pretendard-bold", size: 16.0)
        label.backgroundColor = .clear
        label.setLineHeight(height: 24.0)
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "999"
        switch itemType {
        case .onGoing: label.textColor = UIColor(named: "main_400")
        case .completed: label.textColor = UIColor(named: "gray_400")
        }
        
        return label
    }()
    
    private lazy var highlightView: UIView = {
        let view = UIView()
        
        switch itemType {
        case .onGoing: view.backgroundColor = UIColor(named: "main_400")
        case .completed: view.backgroundColor = UIColor(named: "gray_600")
        }
        
        return view
    }()
    
    init(type: ChallengeTabType) {
        self.itemType = type
        super.init(frame: .zero)
        
        self.setAttributes()
        self.addSubComponents()
        self.setConfigurations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes(){
        
    }
    
    private func addSubComponents(){
        addViewSubComponents()
        addStackViweSubComponents()
    }
    
    private func setConfigurations() {
        makeStackViewConstraints()
        makeHighlightViewConstraints()
    }
}

extension ChallengeTabItem {
    private func addViewSubComponents() {
        [stackView, highlightView].forEach { addSubview($0) }
    }
    
    private func makeStackViewConstraints() {
        stackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func addStackViweSubComponents() {
        [titleLabel, countLabel].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func makeHighlightViewConstraints() {
        highlightView.snp.makeConstraints {
            $0.top.equalTo(highlightView.snp.bottom).offset(-1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeTabItem_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeTabItem_Presentable()
    }
    
    struct ChallengeTabItem_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeTabItem(type: .onGoing)
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
