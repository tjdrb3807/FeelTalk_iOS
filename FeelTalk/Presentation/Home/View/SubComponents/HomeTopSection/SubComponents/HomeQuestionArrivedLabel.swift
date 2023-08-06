//
//  HomeQuestionArrivedLabel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/11.
//

import UIKit
import SnapKit

final class HomeQuestionArrivedLabel: UIView {
    private lazy var totalVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = (UIScreen.main.bounds.height / 100) * 0.49
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "두근두근!"
        label.font = UIFont(name: "pretendard-regular", size: 24.0)
        label.textColor = .white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var bodySectionHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 0.0
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "100"
        label.font = UIFont(name: "pretendard-bold", size: 28.0)
        label.textColor = .white
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "번째 질문이 도착했어요"
        label.font = UIFont(name: "pretendard-regular", size: 24.0)
        label.textColor = .white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    private func setAttribute() {
        backgroundColor = UIColor(named: "main_500")
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConfig() {
        [countLabel, bodyLabel].forEach { bodySectionHorizontalStackView.addArrangedSubview($0) }
        
        [headerLabel, bodySectionHorizontalStackView].forEach { totalVerticalStackView.addArrangedSubview($0) }
        
        headerLabel.snp.makeConstraints { $0.height.equalTo((UIScreen.main.bounds.height / 100) * 4.43)}
        
        addSubview(totalVerticalStackView)
        
        totalVerticalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo((UIScreen.main.bounds.width / 100) * 5.33)
        }
    }
}

#if DEBUG

import SwiftUI

struct HomeQuestionArrivedLabel_Previews: PreviewProvider {
    static var previews: some View {
        HomeQuestionArrivedLabel_Presentable()
    }
    
    struct HomeQuestionArrivedLabel_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            HomeQuestionArrivedLabel()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
