//
//  ChatViewTopSectionBar.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/25.
//

final class ChatViewTopSectionBar: BaseView {
    private lazy var fullHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    lazy var partnerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Pretendard-medium", size: 18.0)
        label.numberOfLines = 1
        label.backgroundColor = .clear
        
        return label
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        // TODO: 이미지 그래픽작업중 -> 추후 변경.
        button.setImage(UIImage(named: "icon_chat_top_menu"), for: .normal)
        button.backgroundColor = .clear
        
        return button
    }()
    
    override func setConfig() {
        [partnerNameLabel, menuButton].forEach { fullHorizontalStackView.addArrangedSubview($0) }
        
        menuButton.snp.makeConstraints { $0.width.equalTo(menuButton.snp.height) }
        
        addSubview(fullHorizontalStackView)
        
        fullHorizontalStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 5.33)
            $0.trailing.equalToSuperview().inset((UIScreen.main.bounds.width / 100) * 3.2)
            $0.centerY.equalToSuperview()
            $0.height.equalTo((UIScreen.main.bounds.height / 100) * 5.911)
        }
    }
}

#if DEBUG

import SwiftUI

struct ChatViewTopSectionBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewTopSectionBar_Presentable()
    }
    
    struct ChatViewTopSectionBar_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            ChatViewTopSectionBar()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
