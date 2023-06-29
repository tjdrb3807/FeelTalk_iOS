//
//  QuestionViewNavigationBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/12.
//

import UIKit
import SnapKit

final class QuestionViewNavigationBar: UIView {
    private lazy var totalHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "질문"
        label.font = UIFont(name: "pretendard-medium", size: 18.0)
        label.textColor = .black
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var pushAlarmViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_gray_alarm_unread"), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var pushChatViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_gray_chat"), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
            
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
    
    private func setAttribute() {
        backgroundColor = UIColor(named: "gray_100")
        
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.08).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 1.0
    }
    
    private func setConfig() {
        [titleLabel, pushAlarmViewButton, pushChatViewButton].forEach { totalHorizontalStackView.addArrangedSubview($0) }
        
        pushAlarmViewButton.snp.makeConstraints { $0.trailing.equalTo(pushChatViewButton.snp.leading).offset(-(UIScreen.main.bounds.width / 100) * 6.66) }
        
        addSubview(totalHorizontalStackView)
        
        totalHorizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            $0.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 3.2)
        }
    }
}

#if DEBUG

import SwiftUI

struct QuestionViewNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        QuestionViewNavigationBar_Presentable()
    }
    
    struct QuestionViewNavigationBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            QuestionViewNavigationBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
