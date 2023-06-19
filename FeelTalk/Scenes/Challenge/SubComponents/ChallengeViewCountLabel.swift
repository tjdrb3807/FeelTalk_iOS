//
//  ChallengeViewCountLabel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/14.
//

import UIKit
import SnapKit

final class ChallengeViewCountLabel: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "너랑 하고 싶은"
        label.font = UIFont(name: "pretendard-regular", size: 24.0)
        label.textColor = .black
        label.backgroundColor = .clear
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "(Count)개의 챌린지"
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() { backgroundColor = .clear }
    
    private func setConfig() {
        [headerLabel, bodyLabel].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChallengeViewCountLabel_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeViewCountLabel_Presentable()
    }
    
    struct ChallengeViewCountLabel_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChallengeViewCountLabel()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
